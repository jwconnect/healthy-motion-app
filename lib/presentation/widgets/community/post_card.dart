import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/post_model.dart';
import 'user_avatar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onUserTap;
  final bool showFullContent;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onUserTap,
    this.showFullContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              _buildHeader(),
              const SizedBox(height: AppSizes.md),

              // 제목
              if (post.title != null) ...[
                Text(
                  post.title!,
                  style: AppTextStyles.headline4,
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              // 본문
              Text(
                post.content,
                style: AppTextStyles.bodyMedium,
                maxLines: showFullContent ? null : 3,
                overflow: showFullContent ? null : TextOverflow.ellipsis,
              ),

              // 이미지
              if (post.hasImages) ...[
                const SizedBox(height: AppSizes.md),
                _buildImages(),
              ],

              const SizedBox(height: AppSizes.md),

              // 액션
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: onUserTap,
          child: Row(
            children: [
              UserAvatar(
                imageUrl: post.user?.profileImageUrl,
                size: 40,
              ),
              const SizedBox(width: AppSizes.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.user?.nickname ?? '사용자',
                    style: AppTextStyles.labelMedium,
                  ),
                  Row(
                    children: [
                      _buildCategoryTag(),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        AppDateUtils.formatRelativeTime(post.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          iconSize: 20,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        post.categoryText,
        style: AppTextStyles.labelSmall.copyWith(
          color: _getCategoryColor(),
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (post.category) {
      case 'certification':
        return AppColors.success;
      case 'question':
        return AppColors.info;
      case 'tip':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildImages() {
    if (post.imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: CachedNetworkImage(
          imageUrl: post.imageUrls.first,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
          placeholder: (context, url) => Container(
            height: 200,
            color: AppColors.background,
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: AppColors.background,
            child: const Icon(Icons.image),
          ),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: post.imageUrls.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: CachedNetworkImage(
              imageUrl: post.imageUrls[index],
              fit: BoxFit.cover,
              width: 150,
              height: 150,
              placeholder: (context, url) => Container(
                width: 150,
                height: 150,
                color: AppColors.background,
              ),
              errorWidget: (context, url, error) => Container(
                width: 150,
                height: 150,
                color: AppColors.background,
                child: const Icon(Icons.image),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: '${post.likeCount}',
          color: post.isLiked ? AppColors.error : AppColors.textSecondary,
          onTap: onLike,
        ),
        const SizedBox(width: AppSizes.lg),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: '${post.commentCount}',
          onTap: onComment,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: post.isBookmarked ? AppColors.primary : AppColors.textSecondary,
          ),
          onPressed: () {},
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
