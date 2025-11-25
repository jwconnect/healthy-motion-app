import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/community/user_avatar.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

class UserProfileScreen extends GetView<ProfileController> {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final userId = args?['id'] as String?;
    if (userId != null) {
      controller.fetchUserProfile(userId);
    }

    return Scaffold(
      appBar: const CustomAppBar(title: '프로필'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final user = controller.viewingUser.value;
        if (user == null) {
          return const Center(child: Text('사용자를 찾을 수 없습니다'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              // 프로필 헤더
              UserAvatar(
                imageUrl: user.profileImageUrl,
                size: 100,
              ),
              const SizedBox(height: AppSizes.md),
              Text(user.nickname, style: AppTextStyles.headline3),
              if (user.bio != null) ...[
                const SizedBox(height: AppSizes.sm),
                Text(
                  user.bio!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSizes.lg),
              // 통계
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('팔로워', user.followerCount),
                  _buildStatItem('팔로잉', user.followingCount),
                  _buildStatItem('운동 시간', user.totalExerciseMinutes),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              // 팔로우 버튼
              CustomButton(
                text: '팔로우',
                onPressed: () {},
                isFullWidth: false,
                width: 200,
              ),
              const SizedBox(height: AppSizes.xl),
              // 게시글 목록 (간략화)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('게시글', style: AppTextStyles.headline4),
              ),
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: const Center(
                  child: Text('게시글이 없습니다'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTextStyles.headline3,
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
