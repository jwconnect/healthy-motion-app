import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '회원가입'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '환영합니다!',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '건강한 동작과 함께 건강한 습관을 시작하세요',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              // 닉네임
              CustomTextField(
                controller: controller.nicknameController,
                label: '닉네임',
                hint: '2~20자 사이로 입력하세요',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: AppSizes.md),
              // 이메일
              CustomTextField(
                controller: controller.emailController,
                label: '이메일',
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: AppSizes.md),
              // 비밀번호
              Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    label: '비밀번호',
                    hint: '8자 이상 입력하세요',
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
              const SizedBox(height: AppSizes.md),
              // 비밀번호 확인
              Obx(() => CustomTextField(
                    controller: controller.confirmPasswordController,
                    label: '비밀번호 확인',
                    hint: '비밀번호를 다시 입력하세요',
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
              const SizedBox(height: AppSizes.xl),
              // 약관 동의
              _buildTermsCheckbox(),
              const SizedBox(height: AppSizes.xl),
              // 회원가입 버튼
              Obx(() => CustomButton(
                    text: '회원가입',
                    onPressed: controller.register,
                    isLoading: controller.isLoading.value,
                  )),
              const SizedBox(height: AppSizes.lg),
              // 로그인 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이미 계정이 있으신가요? ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      '로그인',
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

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: true,
          onChanged: (value) {},
          activeColor: AppColors.primary,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall,
              children: [
                const TextSpan(text: '회원가입 시 '),
                TextSpan(
                  text: '이용약관',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' 및 '),
                TextSpan(
                  text: '개인정보처리방침',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: '에 동의하게 됩니다.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
