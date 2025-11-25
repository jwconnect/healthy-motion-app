import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/comment_model.dart';
import 'user_avatar.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onReply;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onUserTap;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.onReply,
    this.onLike,
    this.onDelete,
    this.onUserTap,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? AppSizes.xl : AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.sm,
        bottom: AppSizes.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onUserTap,
            child: UserAvatar(
              imageUrl: comment.user?.profileImageUrl,
              size: isReply ? 28 : 36,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사용자 정보 & 내용
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${comment.user?.nickname ?? '사용자'} ',
                        style: AppTextStyles.labelMedium,
                      ),
                      TextSpan(
                        text: comment.content,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                // 액션
                Row(
                  children: [
                    Text(
                      AppDateUtils.formatRelativeTime(comment.createdAt),
                      style: AppTextStyles.caption,
                    ),
                    if (comment.likeCount > 0) ...[
                      const SizedBox(width: AppSizes.md),
                      Text(
                        '좋아요 ${comment.likeCount}개',
                        style: AppTextStyles.caption,
                      ),
                    ],
                    if (!isReply) ...[
                      const SizedBox(width: AppSizes.md),
                      GestureDetector(
                        onTap: onReply,
                        child: Text(
                          '답글 달기',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // 대댓글
                if (comment.hasReplies) ...[
                  const SizedBox(height: AppSizes.sm),
                  ...comment.replies.map(
                    (reply) => CommentItem(
                      comment: reply,
                      isReply: true,
                      onLike: () {},
                      onUserTap: () {},
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 좋아요 버튼
          IconButton(
            icon: Icon(
              comment.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: comment.isLiked ? AppColors.error : AppColors.textSecondary,
            ),
            onPressed: onLike,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
