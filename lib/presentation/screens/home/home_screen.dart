import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/motion/motion_card.dart';
import '../../widgets/routine/routine_card.dart';
import '../../widgets/community/post_card.dart';
import '../../widgets/common/loading_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.self_improvement,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              '건강한 동작',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingSection(),
                _buildRecommendedMotions(),
                _buildRoutineSection(),
                _buildCommunitySection(),
                _buildTipCard(),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGreetingSection() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요, ${controller.userNickname}님!',
                  style: AppTextStyles.headline4.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '오늘도 건강한 하루 보내세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedMotions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('오늘의 추천 동작', style: AppTextStyles.headline4),
              TextButton(
                onPressed: () => controller.changeTab(1),
                child: const Text('더보기'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            itemCount: controller.recommendedMotions.length,
            itemBuilder: (context, index) {
              final motion = controller.recommendedMotions[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < controller.recommendedMotions.length - 1
                      ? AppSizes.md
                      : 0,
                ),
                child: MotionHorizontalCard(
                  motion: motion,
                  onTap: () => Get.toNamed(
                    AppRoutes.motionDetail,
                    arguments: motion,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.lg,
            AppSizes.md,
            AppSizes.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('내 루틴', style: AppTextStyles.headline4),
              TextButton(
                onPressed: () => controller.changeTab(2),
                child: const Text('더보기'),
              ),
            ],
          ),
        ),
        if (controller.recentRoutines.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('루틴 만들기'),
                subtitle: const Text('나만의 운동 루틴을 만들어보세요'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(AppRoutes.routineCreate),
              ),
            ),
          )
        else
          ...controller.recentRoutines.take(2).map(
                (routine) => RoutineCard(
                  routine: routine,
                  onTap: () => Get.toNamed(
                    AppRoutes.routineDetail,
                    arguments: routine,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.lg,
            AppSizes.md,
            AppSizes.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('인기 게시글', style: AppTextStyles.headline4),
              TextButton(
                onPressed: () => controller.changeTab(3),
                child: const Text('더보기'),
              ),
            ],
          ),
        ),
        if (controller.popularPosts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Center(
                  child: Text('아직 게시글이 없습니다'),
                ),
              ),
            ),
          )
        else
          ...controller.popularPosts.take(2).map(
                (post) => PostCard(
                  post: post,
                  onTap: () => Get.toNamed(
                    AppRoutes.postDetail,
                    arguments: post,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildTipCard() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘의 건강 팁',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '1시간마다 5분씩 스트레칭을 하면 목과 어깨 통증을 예방할 수 있어요!',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
