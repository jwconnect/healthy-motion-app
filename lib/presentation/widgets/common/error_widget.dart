import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import 'custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CustomErrorWidget({
    super.key,
    this.message,
    this.buttonText,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              message ?? '오류가 발생했습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.lg),
              CustomButton(
                text: buttonText ?? '다시 시도',
                onPressed: onRetry,
                isFullWidth: false,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String? message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData? icon;

  const EmptyWidget({
    super.key,
    this.message,
    this.buttonText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              message ?? '데이터가 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && buttonText != null) ...[
              const SizedBox(height: AppSizes.lg),
              CustomButton(
                text: buttonText!,
                onPressed: onAction,
                isFullWidth: false,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
