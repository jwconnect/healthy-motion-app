import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/routine_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/routine_controller.dart';
import '../../widgets/motion/motion_card.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_app_bar.dart';

class RoutineDetailScreen extends GetView<RoutineController> {
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routine = Get.arguments as RoutineModel?;
    if (routine != null) {
      controller.setRoutine(routine);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: routine?.title ?? '루틴 상세',
        actions: [
          if (routine != null && !routine.isOfficial)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
        ],
      ),
      body: Obx(() {
        final currentRoutine = controller.selectedRoutine.value;
        if (currentRoutine == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 루틴 정보
              Container(
                margin: const EdgeInsets.all(AppSizes.md),
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (currentRoutine.isOfficial) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Text(
                              '공식 루틴',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                        ],
                        Expanded(
                          child: Text(
                            currentRoutine.title,
                            style: AppTextStyles.headline3,
                          ),
                        ),
                      ],
                    ),
                    if (currentRoutine.description != null) ...[
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        currentRoutine.description!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.fitness_center,
                          '${currentRoutine.motionCount}개 동작',
                        ),
                        const SizedBox(width: AppSizes.md),
                        _buildInfoChip(
                          Icons.timer_outlined,
                          currentRoutine.totalDurationText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 동작 목록
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Text(
                  '포함된 동작 (${currentRoutine.motionCount}개)',
                  style: AppTextStyles.headline4,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              ...currentRoutine.motions.asMap().entries.map((entry) {
                final index = entry.key;
                final routineMotion = entry.value;
                final motion = routineMotion.motion;

                return Column(
                  children: [
                    if (motion != null)
                      MotionListTile(
                        motion: motion,
                        onTap: () => Get.toNamed(
                          AppRoutes.motionDetail,
                          arguments: motion,
                        ),
                        trailing: Text(
                          '${index + 1}',
                          style: AppTextStyles.headline4.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    if (index < currentRoutine.motions.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg,
                          vertical: AppSizes.xs,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 2,
                              height: 30,
                              color: AppColors.divider,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              '휴식 ${routineMotion.restSeconds}초',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: CustomButton(
            text: '루틴 시작하기',
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {
              final routine = controller.selectedRoutine.value;
              if (routine != null) {
                Get.toNamed(AppRoutes.routinePlayer, arguments: routine);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
