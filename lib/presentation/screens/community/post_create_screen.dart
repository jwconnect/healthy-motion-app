import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../controllers/community_controller.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_text_field.dart';

class PostCreateScreen extends GetView<CommunityController> {
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '글 작성',
        actions: [
          Obx(() => TextButton(
                onPressed:
                    controller.isLoading.value ? null : controller.createPost,
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('게시'),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 선택
            Text('카테고리', style: AppTextStyles.labelLarge),
            const SizedBox(height: AppSizes.sm),
            Obx(() => Wrap(
                  spacing: AppSizes.sm,
                  children: CategoryModel.communityCategories
                      .where((c) => c.id != 'all')
                      .map((category) {
                    final isSelected =
                        controller.selectedPostCategory.value == category.id;
                    return ChoiceChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedPostCategory.value = category.id;
                        }
                      },
                      selectedColor: AppColors.primaryLight,
                    );
                  }).toList(),
                )),
            const SizedBox(height: AppSizes.lg),
            // 제목
            CustomTextField(
              controller: controller.titleController,
              label: '제목 (선택)',
              hint: '제목을 입력하세요',
            ),
            const SizedBox(height: AppSizes.md),
            // 내용
            CustomTextField(
              controller: controller.contentController,
              label: '내용',
              hint: '내용을 입력하세요',
              maxLines: 10,
              minLines: 5,
            ),
            const SizedBox(height: AppSizes.lg),
            // 이미지 첨부
            Text('이미지 첨부', style: AppTextStyles.labelLarge),
            const SizedBox(height: AppSizes.sm),
            Obx(() => Row(
                  children: [
                    // 이미지 추가 버튼
                    if (controller.selectedImages.length < 5)
                      GestureDetector(
                        onTap: () {
                          // 이미지 선택 로직
                          controller.addImage(
                            'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/200/200',
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: AppSizes.sm),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    // 선택된 이미지들
                    ...controller.selectedImages.asMap().entries.map(
                          (entry) => Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                margin: const EdgeInsets.only(right: AppSizes.sm),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusMd),
                                  image: DecorationImage(
                                    image: NetworkImage(entry.value),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeImage(entry.key),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                )),
            const SizedBox(height: AppSizes.sm),
            Text(
              '최대 5장까지 첨부할 수 있습니다',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
