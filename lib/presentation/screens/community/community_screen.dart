import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/category_model.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/community_controller.dart';
import '../../widgets/community/post_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

class CommunityScreen extends GetView<CommunityController> {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 카테고리 탭
          _buildCategoryTabs(),
          // 게시글 목록
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.posts.isEmpty) {
                return const LoadingWidget();
              }

              if (controller.posts.isEmpty) {
                return EmptyWidget(
                  message: '아직 게시글이 없습니다\n첫 번째 게시글을 작성해보세요!',
                  icon: Icons.article_outlined,
                  buttonText: '글 작성하기',
                  onAction: () => Get.toNamed(AppRoutes.postCreate),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                    itemCount: controller.posts.length +
                        (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSizes.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final post = controller.posts[index];
                      return PostCard(
                        post: post,
                        onTap: () {
                          controller.setPost(post);
                          Get.toNamed(AppRoutes.postDetail, arguments: post);
                        },
                        onLike: () => controller.toggleLike(post.id),
                        onComment: () {
                          controller.setPost(post);
                          Get.toNamed(AppRoutes.postDetail, arguments: post);
                        },
                        onUserTap: () => Get.toNamed(
                          AppRoutes.userProfile,
                          arguments: {'id': post.userId},
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.postCreate),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = CategoryModel.communityCategories;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Obx(() => Row(
              children: categories.map((category) {
                final isSelected =
                    controller.selectedCategory.value == category.id;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: GestureDetector(
                    onTap: () => controller.changeCategory(category.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }
}
