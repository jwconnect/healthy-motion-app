import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/motion_controller.dart';
import '../../widgets/motion/motion_card.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

class MotionListScreen extends GetView<MotionController> {
  const MotionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동작 라이브러리'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 검색바
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: SearchTextField(
              controller: controller.searchController,
              hint: '동작 검색',
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.search('');
                }
              },
              onSubmitted: controller.search,
              onClear: () => controller.search(''),
            ),
          ),
          // 카테고리 필터
          _buildCategoryFilter(),
          // 동작 리스트
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.motions.isEmpty) {
                return EmptyWidget(
                  message: '검색 결과가 없습니다',
                  icon: Icons.search_off,
                  buttonText: '필터 초기화',
                  onAction: controller.clearFilters,
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.md,
                    mainAxisSpacing: AppSizes.md,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.motions.length,
                  itemBuilder: (context, index) {
                    final motion = controller.motions[index];
                    return MotionCard(
                      motion: motion,
                      onTap: () {
                        controller.setMotion(motion);
                        Get.toNamed(AppRoutes.motionDetail, arguments: motion);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Obx(() => Row(
            children: [
              _buildFilterChip(
                label: '전체',
                isSelected: controller.selectedBodyPart.value.isEmpty &&
                    controller.selectedPurpose.value.isEmpty,
                onTap: controller.clearFilters,
              ),
              const SizedBox(width: AppSizes.sm),
              ...CategoryModel.bodyPartCategories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: _buildFilterChip(
                    label: category.name,
                    isSelected: controller.selectedBodyPart.value == category.id,
                    onTap: () => controller.filterByBodyPart(category.id),
                  ),
                ),
              ),
              ...CategoryModel.purposeCategories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: _buildFilterChip(
                    label: category.name,
                    isSelected: controller.selectedPurpose.value == category.id,
                    onTap: () => controller.filterByPurpose(category.id),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
