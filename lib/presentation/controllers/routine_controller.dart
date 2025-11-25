import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/routine_model.dart';
import '../../data/models/motion_model.dart';
import '../../data/repositories/routine_repository.dart';
import '../../data/repositories/record_repository.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_routes.dart';

class RoutineController extends GetxController {
  final RoutineRepository _routineRepository = Get.find<RoutineRepository>();
  final RecordRepository _recordRepository = Get.find<RecordRepository>();

  final userRoutines = <RoutineModel>[].obs;
  final officialRoutines = <RoutineModel>[].obs;
  final isLoading = false.obs;
  final selectedRoutine = Rx<RoutineModel?>(null);

  // 루틴 생성용
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedMotions = <RoutineMotion>[].obs;

  // 루틴 플레이어용
  final currentMotionIndex = 0.obs;
  final isPlaying = false.obs;
  final isResting = false.obs;
  final restTimeRemaining = 0.obs;
  final elapsedSeconds = 0.obs;
  DateTime? _startTime;

  @override
  void onInit() {
    super.onInit();
    fetchRoutines();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchRoutines() async {
    isLoading.value = true;
    try {
      final userResult = await _routineRepository.getUserRoutines();
      final officialResult = await _routineRepository.getOfficialRoutines();
      userRoutines.assignAll(userResult);
      officialRoutines.assignAll(officialResult);
    } catch (e) {
      Helpers.showSnackBar('루틴을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoutineById(String id) async {
    isLoading.value = true;
    try {
      final routine = await _routineRepository.getRoutineById(id);
      selectedRoutine.value = routine;
    } catch (e) {
      Helpers.showSnackBar('루틴 정보를 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void setRoutine(RoutineModel routine) {
    selectedRoutine.value = routine;
  }

  // 루틴 생성
  void addMotionToRoutine(MotionModel motion) {
    final order = selectedMotions.length + 1;
    selectedMotions.add(RoutineMotion(
      motionId: motion.id,
      order: order,
      restSeconds: 10,
      motion: motion,
    ));
  }

  void removeMotionFromRoutine(int index) {
    selectedMotions.removeAt(index);
    // 순서 재정렬
    for (int i = 0; i < selectedMotions.length; i++) {
      selectedMotions[i] = selectedMotions[i].copyWith(order: i + 1);
    }
  }

  void reorderMotions(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final motion = selectedMotions.removeAt(oldIndex);
    selectedMotions.insert(newIndex, motion);
    // 순서 재정렬
    for (int i = 0; i < selectedMotions.length; i++) {
      selectedMotions[i] = selectedMotions[i].copyWith(order: i + 1);
    }
  }

  void updateRestTime(int index, int seconds) {
    selectedMotions[index] = selectedMotions[index].copyWith(restSeconds: seconds);
  }

  Future<void> createRoutine() async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      Helpers.showSnackBar('루틴 이름을 입력해주세요', isError: true);
      return;
    }

    if (selectedMotions.isEmpty) {
      Helpers.showSnackBar('최소 1개 이상의 동작을 추가해주세요', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      await _routineRepository.createRoutine(
        title: title,
        description: descriptionController.text.trim(),
        motions: selectedMotions.toList(),
      );
      Helpers.showSuccessSnackBar('루틴이 생성되었습니다');
      clearCreateForm();
      await fetchRoutines();
      Get.back();
    } catch (e) {
      Helpers.showSnackBar('루틴 생성에 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearCreateForm() {
    titleController.clear();
    descriptionController.clear();
    selectedMotions.clear();
  }

  Future<void> deleteRoutine(String id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '루틴 삭제',
      message: '이 루틴을 삭제하시겠습니까?',
      confirmText: '삭제',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        await _routineRepository.deleteRoutine(id);
        Helpers.showSuccessSnackBar('루틴이 삭제되었습니다');
        await fetchRoutines();
      } catch (e) {
        Helpers.showSnackBar('루틴 삭제에 실패했습니다', isError: true);
      }
    }
  }

  // 루틴 플레이어
  void startRoutine() {
    if (selectedRoutine.value == null) return;
    currentMotionIndex.value = 0;
    isPlaying.value = true;
    isResting.value = false;
    elapsedSeconds.value = 0;
    _startTime = DateTime.now();
  }

  void pauseRoutine() {
    isPlaying.value = false;
  }

  void resumeRoutine() {
    isPlaying.value = true;
  }

  void nextMotion() {
    final routine = selectedRoutine.value;
    if (routine == null) return;

    if (currentMotionIndex.value < routine.motions.length - 1) {
      // 휴식 시간
      final currentMotion = routine.motions[currentMotionIndex.value];
      isResting.value = true;
      restTimeRemaining.value = currentMotion.restSeconds;
      _startRestTimer();
    } else {
      // 루틴 완료
      completeRoutine();
    }
  }

  void _startRestTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!isResting.value) return false;
      restTimeRemaining.value--;
      if (restTimeRemaining.value <= 0) {
        isResting.value = false;
        currentMotionIndex.value++;
        return false;
      }
      return true;
    });
  }

  void skipRest() {
    isResting.value = false;
    restTimeRemaining.value = 0;
    currentMotionIndex.value++;
  }

  void previousMotion() {
    if (currentMotionIndex.value > 0) {
      currentMotionIndex.value--;
      isResting.value = false;
    }
  }

  Future<void> completeRoutine() async {
    isPlaying.value = false;
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!).inSeconds;

    try {
      await _recordRepository.createRecord(
        routineId: selectedRoutine.value!.id,
        startedAt: _startTime!,
        completedAt: endTime,
        durationSeconds: duration,
        routineTitle: selectedRoutine.value!.title,
      );

      Get.dialog(
        AlertDialog(
          title: const Text('루틴 완료!'),
          content: Text('수고하셨습니다!\n총 ${duration ~/ 60}분 ${duration % 60}초 운동했습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.offNamed(AppRoutes.main);
              },
              child: const Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Helpers.showSnackBar('기록 저장에 실패했습니다', isError: true);
    }
  }

  void stopRoutine() async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '루틴 중단',
      message: '루틴을 중단하시겠습니까?',
      confirmText: '중단',
    );

    if (confirmed == true) {
      isPlaying.value = false;
      Get.back();
    }
  }

  MotionModel? get currentMotion {
    final routine = selectedRoutine.value;
    if (routine == null || currentMotionIndex.value >= routine.motions.length) {
      return null;
    }
    return routine.motions[currentMotionIndex.value].motion;
  }

  int get totalMotions => selectedRoutine.value?.motions.length ?? 0;
}
