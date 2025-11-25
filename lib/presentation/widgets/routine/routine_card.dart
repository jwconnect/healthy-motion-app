import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/routine_model.dart';

class RoutineCard extends StatelessWidget {
  final RoutineModel routine;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const RoutineCard({
    super.key,
    required this.routine,
    this.onTap,
    this.onDelete,
    this.showDeleteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Row(
              children: [
                // 썸네일
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusLg),
                    bottomLeft: Radius.circular(AppSizes.radiusLg),
                  ),
                  child: routine.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: routine.thumbnailUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            color: AppColors.background,
                          ),
                          errorWidget: (context, url, error) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                // 정보
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (routine.isOfficial) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusSm),
                                ),
                                child: Text(
                                  '공식',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.sm),
                            ],
                            Expanded(
                              child: Text(
                                routine.title,
                                style: AppTextStyles.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (routine.description != null) ...[
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            routine.description!,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSizes.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${routine.motionCount}개 동작',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(width: AppSizes.md),
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              routine.totalDurationText,
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 화살표
                Padding(
                  padding: const EdgeInsets.only(right: AppSizes.md),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (showDeleteButton && onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.primaryLight.withOpacity(0.2),
      child: const Icon(
        Icons.self_improvement,
        size: 40,
        color: AppColors.primary,
      ),
    );
  }
}

class RoutineProgressCard extends StatelessWidget {
  final RoutineModel routine;
  final int currentIndex;
  final VoidCallback? onTap;

  const RoutineProgressCard({
    super.key,
    required this.routine,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentIndex / routine.motionCount;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    routine.title,
                    style: AppTextStyles.labelLarge,
                  ),
                  Text(
                    '$currentIndex/${routine.motionCount}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '루틴 이어하기',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
