import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/motion_model.dart';

class MotionCard extends StatelessWidget {
  final MotionModel motion;
  final VoidCallback? onTap;
  final bool showLikeButton;
  final VoidCallback? onLike;

  const MotionCard({
    super.key,
    required this.motion,
    this.onTap,
    this.showLikeButton = false,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: motion.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: AppColors.background,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.fitness_center, size: 48),
                    ),
                  ),
                  // 시간 표시
                  Positioned(
                    right: AppSizes.sm,
                    bottom: AppSizes.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        motion.durationText,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 정보
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motion.title,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      _buildTag(
                        motion.difficultyText,
                        Helpers.getDifficultyColor(motion.difficulty),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Icon(
                        Icons.favorite,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${motion.likeCount}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: 2,
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
}

class MotionListTile extends StatelessWidget {
  final MotionModel motion;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MotionListTile({
    super.key,
    required this.motion,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: CachedNetworkImage(
          imageUrl: motion.thumbnailUrl,
          width: 80,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 80,
            height: 60,
            color: AppColors.background,
          ),
          errorWidget: (context, url, error) => Container(
            width: 80,
            height: 60,
            color: AppColors.background,
            child: const Icon(Icons.fitness_center),
          ),
        ),
      ),
      title: Text(
        motion.title,
        style: AppTextStyles.labelLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            motion.durationText,
            style: AppTextStyles.caption,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            '•',
            style: AppTextStyles.caption,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            motion.difficultyText,
            style: AppTextStyles.caption.copyWith(
              color: Helpers.getDifficultyColor(motion.difficulty),
            ),
          ),
        ],
      ),
      trailing: trailing,
    );
  }
}

class MotionHorizontalCard extends StatelessWidget {
  final MotionModel motion;
  final VoidCallback? onTap;
  final double width;

  const MotionHorizontalCard({
    super.key,
    required this.motion,
    this.onTap,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: motion.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: AppColors.background,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.background,
                        child: const Icon(Icons.fitness_center),
                      ),
                    ),
                    Positioned(
                      right: AppSizes.xs,
                      bottom: AppSizes.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          motion.durationText,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motion.title,
                      style: AppTextStyles.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      motion.difficultyText,
                      style: AppTextStyles.caption.copyWith(
                        color: Helpers.getDifficultyColor(motion.difficulty),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
