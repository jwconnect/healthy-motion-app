import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nicknameController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isGuest => currentUser.value?.isGuest ?? false;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authRepository.currentUser;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nicknameController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Helpers.showSnackBar('이메일과 비밀번호를 입력해주세요', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.login(email, password);
      currentUser.value = user;
      clearControllers();
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Helpers.showSnackBar('로그인에 실패했습니다: ${e.toString()}', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final nickname = nicknameController.text.trim();

    if (email.isEmpty || password.isEmpty || nickname.isEmpty) {
      Helpers.showSnackBar('모든 필수 항목을 입력해주세요', isError: true);
      return;
    }

    if (password != confirmPassword) {
      Helpers.showSnackBar('비밀번호가 일치하지 않습니다', isError: true);
      return;
    }

    if (password.length < 8) {
      Helpers.showSnackBar('비밀번호는 8자 이상이어야 합니다', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        nickname: nickname,
      );
      currentUser.value = user;
      clearControllers();
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Helpers.showSnackBar('회원가입에 실패했습니다: ${e.toString()}', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Helpers.showSnackBar('이메일을 입력해주세요', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.forgotPassword(email);
      Helpers.showSuccessSnackBar('비밀번호 재설정 이메일을 발송했습니다');
      Get.back();
    } catch (e) {
      Helpers.showSnackBar('이메일 발송에 실패했습니다: ${e.toString()}', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '로그아웃',
      message: '정말 로그아웃하시겠습니까?',
      confirmText: '로그아웃',
    );

    if (confirmed == true) {
      await _authRepository.logout();
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> deleteAccount() async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '회원 탈퇴',
      message: '정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
      confirmText: '탈퇴하기',
      isDangerous: true,
    );

    if (confirmed == true) {
      isLoading.value = true;
      try {
        await _authRepository.deleteAccount();
        currentUser.value = null;
        Get.offAllNamed(AppRoutes.login);
        Helpers.showSuccessSnackBar('회원 탈퇴가 완료되었습니다');
      } catch (e) {
        Helpers.showSnackBar('회원 탈퇴에 실패했습니다', isError: true);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nicknameController.clear();
  }

  Future<void> loginAsGuest() async {
    isLoading.value = true;
    try {
      final user = await _authRepository.loginAsGuest();
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Helpers.showSnackBar('게스트 로그인에 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertGuestToUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final nickname = nicknameController.text.trim();

    if (email.isEmpty || password.isEmpty || nickname.isEmpty) {
      Helpers.showSnackBar('모든 필수 항목을 입력해주세요', isError: true);
      return;
    }

    if (password != confirmPassword) {
      Helpers.showSnackBar('비밀번호가 일치하지 않습니다', isError: true);
      return;
    }

    if (password.length < 8) {
      Helpers.showSnackBar('비밀번호는 8자 이상이어야 합니다', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.convertGuestToUser(
        email: email,
        password: password,
        nickname: nickname,
      );
      currentUser.value = user;
      clearControllers();
      Helpers.showSuccessSnackBar('계정이 생성되었습니다');
      Get.back();
    } catch (e) {
      Helpers.showSnackBar('계정 생성에 실패했습니다: ${e.toString()}', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
