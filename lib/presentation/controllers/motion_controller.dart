import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/motion_model.dart';
import '../../data/repositories/motion_repository.dart';
import '../../core/utils/helpers.dart';

class MotionController extends GetxController {
  final MotionRepository _repository = Get.find<MotionRepository>();

  final motions = <MotionModel>[].obs;
  final recommendedMotions = <MotionModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final selectedMotion = Rx<MotionModel?>(null);

  // 필터
  final selectedBodyPart = ''.obs;
  final selectedPurpose = ''.obs;
  final selectedDifficulty = ''.obs;
  final searchQuery = ''.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchMotions();
    fetchRecommendedMotions();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchMotions() async {
    isLoading.value = true;
    try {
      final result = await _repository.getMotions(
        bodyPart: selectedBodyPart.value.isEmpty ? null : selectedBodyPart.value,
        purpose: selectedPurpose.value.isEmpty ? null : selectedPurpose.value,
        difficulty: selectedDifficulty.value.isEmpty ? null : selectedDifficulty.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      motions.assignAll(result);
    } catch (e) {
      Helpers.showSnackBar('동작을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecommendedMotions() async {
    try {
      final result = await _repository.getRecommendedMotions();
      recommendedMotions.assignAll(result);
    } catch (e) {
      // 추천 동작 로딩 실패는 조용히 처리
    }
  }

  Future<void> fetchMotionById(String id) async {
    isLoading.value = true;
    try {
      final motion = await _repository.getMotionById(id);
      selectedMotion.value = motion;
      if (motion != null) {
        await _repository.incrementViewCount(id);
      }
    } catch (e) {
      Helpers.showSnackBar('동작 정보를 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void setMotion(MotionModel motion) {
    selectedMotion.value = motion;
  }

  void filterByBodyPart(String bodyPart) {
    if (selectedBodyPart.value == bodyPart) {
      selectedBodyPart.value = '';
    } else {
      selectedBodyPart.value = bodyPart;
    }
    fetchMotions();
  }

  void filterByPurpose(String purpose) {
    if (selectedPurpose.value == purpose) {
      selectedPurpose.value = '';
    } else {
      selectedPurpose.value = purpose;
    }
    fetchMotions();
  }

  void filterByDifficulty(String difficulty) {
    if (selectedDifficulty.value == difficulty) {
      selectedDifficulty.value = '';
    } else {
      selectedDifficulty.value = difficulty;
    }
    fetchMotions();
  }

  void search(String query) {
    searchQuery.value = query;
    fetchMotions();
  }

  void clearFilters() {
    selectedBodyPart.value = '';
    selectedPurpose.value = '';
    selectedDifficulty.value = '';
    searchQuery.value = '';
    searchController.clear();
    fetchMotions();
  }

  Future<void> toggleLike(String motionId) async {
    final index = motions.indexWhere((m) => m.id == motionId);
    if (index == -1) return;

    final motion = motions[index];
    final newIsLiked = !motion.isLiked;

    // Optimistic update
    motions[index] = motion.copyWith(
      isLiked: newIsLiked,
      likeCount: newIsLiked ? motion.likeCount + 1 : motion.likeCount - 1,
    );

    if (selectedMotion.value?.id == motionId) {
      selectedMotion.value = motions[index];
    }

    try {
      if (newIsLiked) {
        await _repository.likeMotion(motionId);
      } else {
        await _repository.unlikeMotion(motionId);
      }
    } catch (e) {
      // Rollback on error
      motions[index] = motion;
      if (selectedMotion.value?.id == motionId) {
        selectedMotion.value = motion;
      }
      Helpers.showSnackBar('좋아요 처리에 실패했습니다', isError: true);
    }
  }

  Future<void> refresh() async {
    await fetchMotions();
    await fetchRecommendedMotions();
  }
}
