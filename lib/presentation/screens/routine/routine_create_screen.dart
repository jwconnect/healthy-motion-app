import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/routine_controller.dart';
import '../../controllers/motion_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/motion/motion_card.dart';

class RoutineCreateScreen extends GetView<RoutineController> {
  const RoutineCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '루틴 만들기',
        actions: [
          TextButton(
            onPressed: controller.createRoutine,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기본 정보
            CustomTextField(
              controller: controller.titleController,
              label: '루틴 이름',
              hint: '루틴 이름을 입력하세요',
            ),
            const SizedBox(height: AppSizes.md),
            CustomTextField(
              controller: controller.descriptionController,
              label: '설명 (선택)',
              hint: '루틴에 대한 간단한 설명',
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.lg),
            // 동작 목록
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('동작 목록', style: AppTextStyles.headline4),
                TextButton.icon(
                  onPressed: () => _showMotionPicker(context),
                  icon: const Icon(Icons.add),
                  label: const Text('동작 추가'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Obx(() {
              if (controller.selectedMotions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: AppSizes.sm),
                        Text(
                          '동작을 추가해주세요',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.selectedMotions.length,
                onReorder: controller.reorderMotions,
                itemBuilder: (context, index) {
                  final routineMotion = controller.selectedMotions[index];
                  final motion = routineMotion.motion;

                  return Card(
                    key: ValueKey(routineMotion.motionId),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.drag_handle, color: AppColors.textHint),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            '${index + 1}',
                            style: AppTextStyles.headline4.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      title: Text(motion?.title ?? '동작'),
                      subtitle: Text('휴식 ${routineMotion.restSeconds}초'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => controller.removeMotionFromRoutine(index),
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: AppSizes.lg),
            // 총 시간
            Obx(() {
              if (controller.selectedMotions.isEmpty) {
                return const SizedBox.shrink();
              }

              final totalSeconds = controller.selectedMotions.fold<int>(
                0,
                (sum, m) => sum + (m.motion?.durationSeconds ?? 0) + m.restSeconds,
              );
              final minutes = totalSeconds ~/ 60;
              final seconds = totalSeconds % 60;

              return Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 예상 시간', style: AppTextStyles.labelLarge),
                    Text(
                      seconds > 0 ? '$minutes분 $seconds초' : '$minutes분',
                      style: AppTextStyles.headline4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Obx(() => CustomButton(
                text: '루틴 저장',
                onPressed: controller.selectedMotions.isNotEmpty
                    ? controller.createRoutine
                    : null,
                isLoading: controller.isLoading.value,
              )),
        ),
      ),
    );
  }

  void _showMotionPicker(BuildContext context) {
    final motionController = Get.find<MotionController>();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('동작 선택', style: AppTextStyles.headline4),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: motionController.motions.length,
                    itemBuilder: (context, index) {
                      final motion = motionController.motions[index];
                      return MotionListTile(
                        motion: motion,
                        onTap: () {
                          controller.addMotionToRoutine(motion);
                          Get.back();
                        },
                        trailing: const Icon(Icons.add),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
