import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../core/utils/helpers.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  final currentUser = Rx<UserModel?>(null);
  final viewingUser = Rx<UserModel?>(null);
  final isLoading = false.obs;

  // 프로필 수정용
  final nicknameController = TextEditingController();
  final bioController = TextEditingController();
  final selectedProfileImage = Rx<String?>(null);

  // 설정
  final isDarkMode = false.obs;
  final isNotificationEnabled = true.obs;
  final isAutoPlayVideo = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadSettings();
  }

  @override
  void onClose() {
    nicknameController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void loadCurrentUser() {
    currentUser.value = _authRepository.currentUser;
    if (currentUser.value != null) {
      nicknameController.text = currentUser.value!.nickname;
      bioController.text = currentUser.value!.bio ?? '';
      selectedProfileImage.value = currentUser.value!.profileImageUrl;
    }
  }

  void loadSettings() {
    isDarkMode.value = _localStorage.isDarkMode();
    isNotificationEnabled.value = _localStorage.isNotificationEnabled();
    isAutoPlayVideo.value = _localStorage.isAutoPlayVideo();
  }

  Future<void> updateProfile() async {
    final nickname = nicknameController.text.trim();

    if (nickname.isEmpty) {
      Helpers.showSnackBar('닉네임을 입력해주세요', isError: true);
      return;
    }

    if (nickname.length < 2) {
      Helpers.showSnackBar('닉네임은 2자 이상이어야 합니다', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final updatedUser = await _authRepository.updateProfile(
        nickname: nickname,
        bio: bioController.text.trim(),
        profileImageUrl: selectedProfileImage.value,
      );
      currentUser.value = updatedUser;
      Helpers.showSuccessSnackBar('프로필이 업데이트되었습니다');
      Get.back();
    } catch (e) {
      Helpers.showSnackBar('프로필 업데이트에 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectProfileImage(String imagePath) {
    selectedProfileImage.value = imagePath;
  }

  // 설정 변경
  Future<void> toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    await _localStorage.setDarkMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleNotification() async {
    isNotificationEnabled.value = !isNotificationEnabled.value;
    await _localStorage.setNotificationEnabled(isNotificationEnabled.value);
  }

  Future<void> toggleAutoPlayVideo() async {
    isAutoPlayVideo.value = !isAutoPlayVideo.value;
    await _localStorage.setAutoPlayVideo(isAutoPlayVideo.value);
  }

  Future<void> clearCache() async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '캐시 삭제',
      message: '캐시를 삭제하시겠습니까?',
      confirmText: '삭제',
    );

    if (confirmed == true) {
      // 캐시 삭제 로직
      Helpers.showSuccessSnackBar('캐시가 삭제되었습니다');
    }
  }

  // 다른 사용자 프로필 조회
  Future<void> fetchUserProfile(String userId) async {
    isLoading.value = true;
    try {
      // 실제 구현에서는 API 호출
      await Future.delayed(const Duration(milliseconds: 500));
      viewingUser.value = UserModel(
        id: userId,
        email: 'user@example.com',
        nickname: '사용자',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      Helpers.showSnackBar('사용자 정보를 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
