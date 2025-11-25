import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/community/user_avatar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            _buildProfileHeader(),
            const SizedBox(height: AppSizes.md),
            // 활동 요약
            _buildActivitySummary(),
            const SizedBox(height: AppSizes.lg),
            // 메뉴
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final user = controller.currentUser.value;
      return Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            UserAvatar(
              imageUrl: user?.profileImageUrl,
              size: 80,
            ),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.nickname ?? '사용자',
                    style: AppTextStyles.headline3,
                  ),
                  if (user?.bio != null) ...[
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      user!.bio!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.sm),
                  OutlinedButton(
                    onPressed: () => Get.toNamed(AppRoutes.editProfile),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.xs,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('프로필 수정'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActivitySummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: _buildActivityCard(
              icon: Icons.calendar_today,
              label: '운동 기록',
              onTap: () => Get.toNamed(AppRoutes.records),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _buildActivityCard(
              icon: Icons.article_outlined,
              label: '내 게시글',
              onTap: () {},
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _buildActivityCard(
              icon: Icons.favorite_border,
              label: '좋아요',
              onTap: () {},
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _buildActivityCard(
              icon: Icons.bookmark_border,
              label: '북마크',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSizes.xs),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: '알림 설정',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: '앱 설정',
          onTap: () => Get.toNamed(AppRoutes.settings),
        ),
        const Divider(height: 1),
        _buildMenuItem(
          icon: Icons.campaign_outlined,
          title: '공지사항',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: '자주 묻는 질문',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.mail_outline,
          title: '문의하기',
          onTap: () {},
        ),
        const Divider(height: 1),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: '이용약관',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: '개인정보처리방침',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: '버전 정보',
          trailing: const Text(
            'v1.0.0',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          onTap: () {},
        ),
        const Divider(height: 1),
        _buildMenuItem(
          icon: Icons.logout,
          title: '로그아웃',
          color: AppColors.error,
          onTap: () {
            Get.find<AuthController>().logout();
          },
        ),
        const SizedBox(height: AppSizes.xl),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(color: color ?? AppColors.textPrimary),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
