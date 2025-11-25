import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/routine_model.dart';
import '../../controllers/routine_controller.dart';
import '../../widgets/common/custom_button.dart';

class RoutinePlayerScreen extends GetView<RoutineController> {
  const RoutinePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routine = Get.arguments as RoutineModel?;
    if (routine != null) {
      controller.setRoutine(routine);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.startRoutine();
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.stopRoutine();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          final currentMotion = controller.currentMotion;
          final isResting = controller.isResting.value;

          if (isResting) {
            return _buildRestingView();
          }

          if (currentMotion == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return Stack(
            children: [
              // 영상/이미지
              Center(
                child: CachedNetworkImage(
                  imageUrl: currentMotion.thumbnailUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // 오버레이
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // 상단 정보
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: controller.stopRoutine,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                            ),
                            child: Text(
                              '${controller.currentMotionIndex.value + 1} / ${controller.totalMotions}',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // 균형
                        ],
                      ),
                      const Spacer(),
                      // 동작 제목
                      Text(
                        currentMotion.title,
                        style: AppTextStyles.headline2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        currentMotion.durationText,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      // 컨트롤
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: controller.currentMotionIndex.value > 0
                                ? controller.previousMotion
                                : null,
                          ),
                          const SizedBox(width: AppSizes.lg),
                          GestureDetector(
                            onTap: () {
                              if (controller.isPlaying.value) {
                                controller.pauseRoutine();
                              } else {
                                controller.resumeRoutine();
                              }
                            },
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                controller.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.lg),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: controller.nextMotion,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      // 진행바
                      LinearProgressIndicator(
                        value: (controller.currentMotionIndex.value + 1) /
                            controller.totalMotions,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: AppSizes.md),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRestingView() {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                '휴식 시간',
                style: AppTextStyles.headline3.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Obx(() => Text(
                    '${controller.restTimeRemaining.value}',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(height: AppSizes.xl),
              CustomButton(
                text: '건너뛰기',
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                isFullWidth: false,
                width: 150,
                onPressed: controller.skipRest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
