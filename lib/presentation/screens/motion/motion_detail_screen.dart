import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/motion_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/motion_controller.dart';
import '../../widgets/common/custom_button.dart';

class MotionDetailScreen extends GetView<MotionController> {
  const MotionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final motion = Get.arguments as MotionModel?;
    if (motion != null) {
      controller.setMotion(motion);
    }

    return Scaffold(
      body: Obx(() {
        final currentMotion = controller.selectedMotion.value;
        if (currentMotion == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // 영상 플레이어 / 썸네일
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: currentMotion.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          AppRoutes.motionPlayer,
                          arguments: currentMotion,
                        ),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
            // 내용
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 & 좋아요
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            currentMotion.title,
                            style: AppTextStyles.headline2,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            currentMotion.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: currentMotion.isLiked
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                          onPressed: () => controller.toggleLike(currentMotion.id),
                        ),
                      ],
                    ),
                    // 태그
                    Wrap(
                      spacing: AppSizes.sm,
                      runSpacing: AppSizes.sm,
                      children: [
                        _buildTag(
                          currentMotion.difficultyText,
                          Helpers.getDifficultyColor(currentMotion.difficulty),
                        ),
                        _buildTag(currentMotion.durationText, AppColors.secondary),
                        ...currentMotion.bodyParts.map(
                          (bp) => _buildTag(
                            Helpers.getBodyPartText(bp),
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    // 조회수, 좋아요
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          '${currentMotion.viewCount}회',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppSizes.md),
                        Icon(Icons.favorite, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          '${currentMotion.likeCount}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.lg),
                    const Divider(),
                    const SizedBox(height: AppSizes.lg),
                    // 설명
                    Text('설명', style: AppTextStyles.headline4),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      currentMotion.description,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    // 수행 방법
                    if (currentMotion.steps.isNotEmpty) ...[
                      Text('수행 방법', style: AppTextStyles.headline4),
                      const SizedBox(height: AppSizes.sm),
                      ...currentMotion.steps.asMap().entries.map(
                            (entry) => _buildStepItem(entry.key + 1, entry.value),
                          ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                    // 주의사항
                    if (currentMotion.cautions.isNotEmpty) ...[
                      Text('주의사항', style: AppTextStyles.headline4),
                      const SizedBox(height: AppSizes.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        child: Column(
                          children: currentMotion.cautions
                              .map((caution) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSizes.xs,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber,
                                          size: 18,
                                          color: AppColors.warning,
                                        ),
                                        const SizedBox(width: AppSizes.sm),
                                        Expanded(
                                          child: Text(
                                            caution,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSizes.xxl),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: '루틴에 추가',
                  isOutlined: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: CustomButton(
                  text: '동작 시작',
                  onPressed: () {
                    final motion = controller.selectedMotion.value;
                    if (motion != null) {
                      Get.toNamed(AppRoutes.motionPlayer, arguments: motion);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
