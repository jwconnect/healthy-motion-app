import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class Helpers {
  Helpers._();

  static void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      isError ? '오류' : '알림',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  static void showSuccessSnackBar(String message) {
    Get.snackbar(
      '성공',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  static void showLoading({String? message}) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDangerous = false,
  }) async {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: isDangerous ? AppColors.error : AppColors.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static String getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '초급';
      case 'intermediate':
        return '중급';
      case 'advanced':
        return '고급';
      default:
        return difficulty;
    }
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.beginnerColor;
      case 'intermediate':
        return AppColors.intermediateColor;
      case 'advanced':
        return AppColors.advancedColor;
      default:
        return AppColors.textSecondary;
    }
  }

  static String getBodyPartText(String bodyPart) {
    final bodyPartMap = {
      'neck': '목',
      'shoulder': '어깨',
      'back': '등',
      'waist': '허리',
      'lower_body': '하체',
      'full_body': '전신',
      'wrist': '손목',
      'ankle': '발목',
    };
    return bodyPartMap[bodyPart.toLowerCase()] ?? bodyPart;
  }

  static String getPurposeText(String purpose) {
    final purposeMap = {
      'stretching': '스트레칭',
      'posture': '자세교정',
      'pain_relief': '통증완화',
      'strength': '근력강화',
      'relax': '릴렉스',
    };
    return purposeMap[purpose.toLowerCase()] ?? purpose;
  }

  static String getCategoryText(String category) {
    final categoryMap = {
      'certification': '인증',
      'question': '질문',
      'tip': '팁 공유',
      'free': '자유',
    };
    return categoryMap[category.toLowerCase()] ?? category;
  }
}
