import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.xxl),
              // 로고
              _buildLogo(),
              const SizedBox(height: AppSizes.xxl),
              // 환영 메시지
              Text(
                '다시 만나서 반가워요!',
                style: AppTextStyles.headline2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '로그인하고 건강한 습관을 이어가세요',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xl),
              // 이메일 입력
              CustomTextField(
                controller: controller.emailController,
                label: '이메일',
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: AppSizes.md),
              // 비밀번호 입력
              Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    label: '비밀번호',
                    hint: '비밀번호를 입력하세요',
                    obscureText: !controller.isPasswordVisible.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
              const SizedBox(height: AppSizes.sm),
              // 비밀번호 찾기
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                  child: Text(
                    '비밀번호를 잊으셨나요?',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              // 로그인 버튼
              Obx(() => CustomButton(
                    text: '로그인',
                    onPressed: controller.login,
                    isLoading: controller.isLoading.value,
                  )),
              const SizedBox(height: AppSizes.lg),
              // 또는
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Text(
                      '또는',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              // 소셜 로그인
              _buildSocialLoginButton(
                icon: Icons.g_mobiledata,
                text: 'Google로 계속하기',
                onPressed: () {},
              ),
              const SizedBox(height: AppSizes.md),
              _buildSocialLoginButton(
                icon: Icons.apple,
                text: 'Apple로 계속하기',
                onPressed: () {},
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
              const SizedBox(height: AppSizes.xl),
              // 게스트 로그인
              Obx(() => TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.loginAsGuest,
                    child: Text(
                      '로그인 없이 둘러보기',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )),
              const SizedBox(height: AppSizes.md),
              // 회원가입 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '아직 계정이 없으신가요? ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: Text(
                      '회원가입',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.self_improvement,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          '건강한 동작',
          style: AppTextStyles.headline3.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return SizedBox(
      height: AppSizes.buttonHeightMd,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? AppColors.textPrimary,
          side: backgroundColor != null
              ? BorderSide.none
              : const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: AppSizes.sm),
            Text(text),
          ],
        ),
      ),
    );
  }
}
