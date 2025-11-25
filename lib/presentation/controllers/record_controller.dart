import 'package:get/get.dart';
import '../../data/models/record_model.dart';
import '../../data/repositories/record_repository.dart';
import '../../core/utils/helpers.dart';

class RecordController extends GetxController {
  final RecordRepository _repository = Get.find<RecordRepository>();

  final records = <RecordModel>[].obs;
  final dailyRecords = <DateTime, List<RecordModel>>{}.obs;
  final statistics = Rx<ExerciseStatistics?>(null);
  final isLoading = false.obs;

  final selectedDate = DateTime.now().obs;
  final focusedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
    fetchStatistics();
    fetchMonthlyRecords(DateTime.now().year, DateTime.now().month);
  }

  Future<void> fetchRecords() async {
    isLoading.value = true;
    try {
      final result = await _repository.getRecords();
      records.assignAll(result);
    } catch (e) {
      Helpers.showSnackBar('기록을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecordsByDate(DateTime date) async {
    try {
      final result = await _repository.getRecordsByDate(date);
      // 해당 날짜의 기록 업데이트
      dailyRecords[DateTime(date.year, date.month, date.day)] = result;
    } catch (e) {
      // 조용히 처리
    }
  }

  Future<void> fetchMonthlyRecords(int year, int month) async {
    try {
      final result = await _repository.getMonthlyRecords(year, month);
      dailyRecords.addAll(result);
    } catch (e) {
      // 조용히 처리
    }
  }

  Future<void> fetchStatistics() async {
    try {
      final result = await _repository.getStatistics();
      statistics.value = result;
    } catch (e) {
      Helpers.showSnackBar('통계를 불러오는데 실패했습니다', isError: true);
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchRecordsByDate(date);
  }

  void changeMonth(DateTime date) {
    focusedDate.value = date;
    fetchMonthlyRecords(date.year, date.month);
  }

  List<RecordModel> getRecordsForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return dailyRecords[key] ?? [];
  }

  bool hasRecordOnDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return dailyRecords.containsKey(key) && dailyRecords[key]!.isNotEmpty;
  }

  int getTotalMinutesForDate(DateTime date) {
    final dateRecords = getRecordsForDate(date);
    return dateRecords.fold<int>(0, (sum, r) => sum + r.durationSeconds) ~/ 60;
  }

  Future<void> refresh() async {
    await fetchRecords();
    await fetchStatistics();
    await fetchMonthlyRecords(focusedDate.value.year, focusedDate.value.month);
  }
}
