import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/post_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/community_controller.dart';
import '../../widgets/community/post_card.dart';
import '../../widgets/community/comment_item.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

class PostDetailScreen extends GetView<CommunityController> {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Get.arguments as PostModel?;
    if (post != null) {
      controller.setPost(post);
      controller.fetchComments(post.id);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: '게시글',
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                controller.deletePost(post?.id ?? '');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: AppSizes.sm),
                    Text('공유하기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined),
                    SizedBox(width: AppSizes.sm),
                    Text('신고하기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.error),
                    SizedBox(width: AppSizes.sm),
                    Text('삭제하기', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final currentPost = controller.selectedPost.value;
        if (currentPost == null) {
          return const LoadingWidget();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 게시글
                    PostCard(
                      post: currentPost,
                      showFullContent: true,
                      onLike: () => controller.toggleLike(currentPost.id),
                      onUserTap: () => Get.toNamed(
                        AppRoutes.userProfile,
                        arguments: {'id': currentPost.userId},
                      ),
                    ),
                    const Divider(height: 1),
                    // 댓글 섹션
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Text(
                        '댓글 ${currentPost.commentCount}개',
                        style: AppTextStyles.headline4,
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoadingComments.value) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSizes.lg),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (controller.comments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSizes.xl),
                          child: Center(
                            child: Text(
                              '아직 댓글이 없습니다\n첫 댓글을 남겨보세요!',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.comments.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final comment = controller.comments[index];
                          return CommentItem(
                            comment: comment,
                            onReply: () => controller.startReply(comment),
                            onLike: () {},
                            onUserTap: () => Get.toNamed(
                              AppRoutes.userProfile,
                              arguments: {'id': comment.userId},
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
            // 댓글 입력
            _buildCommentInput(),
          ],
        );
      }),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.sm,
        bottom: MediaQuery.of(Get.context!).padding.bottom + AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 답글 표시
          Obx(() {
            if (controller.replyingToComment.value != null) {
              return Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                margin: const EdgeInsets.only(bottom: AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: [
                    Text(
                      '@${controller.replyingToComment.value!.user?.nickname ?? '사용자'}에게 답글',
                      style: AppTextStyles.caption,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: controller.cancelReply,
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.commentController,
                  decoration: InputDecoration(
                    hintText: '댓글을 입력하세요',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: controller.createComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
