import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '비밀번호 찾기'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.xl),
              // 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                '비밀번호를 잊으셨나요?',
                style: AppTextStyles.headline2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '가입할 때 사용한 이메일을 입력하시면\n비밀번호 재설정 링크를 보내드립니다.',
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
              const SizedBox(height: AppSizes.xl),
              // 전송 버튼
              Obx(() => CustomButton(
                    text: '재설정 링크 보내기',
                    onPressed: controller.forgotPassword,
                    isLoading: controller.isLoading.value,
                  )),
              const SizedBox(height: AppSizes.lg),
              // 로그인으로 돌아가기
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  '로그인으로 돌아가기',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
