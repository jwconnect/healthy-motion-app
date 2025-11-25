import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/routine_controller.dart';
import '../../widgets/routine/routine_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

class RoutineListScreen extends GetView<RoutineController> {
  const RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 루틴'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRoutines,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 내 루틴
                Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Text('내가 만든 루틴', style: AppTextStyles.headline4),
                ),
                if (controller.userRoutines.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: EmptyWidget(
                      message: '아직 만든 루틴이 없습니다\n새로운 루틴을 만들어보세요!',
                      icon: Icons.playlist_add,
                    ),
                  )
                else
                  ...controller.userRoutines.map(
                    (routine) => RoutineCard(
                      routine: routine,
                      showDeleteButton: true,
                      onTap: () {
                        controller.setRoutine(routine);
                        Get.toNamed(AppRoutes.routineDetail, arguments: routine);
                      },
                      onDelete: () => controller.deleteRoutine(routine.id),
                    ),
                  ),
                const SizedBox(height: AppSizes.lg),
                // 추천 루틴
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text('추천 루틴', style: AppTextStyles.headline4),
                ),
                const SizedBox(height: AppSizes.sm),
                ...controller.officialRoutines.map(
                  (routine) => RoutineCard(
                    routine: routine,
                    onTap: () {
                      controller.setRoutine(routine);
                      Get.toNamed(AppRoutes.routineDetail, arguments: routine);
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.routineCreate),
        icon: const Icon(Icons.add),
        label: const Text('루틴 만들기'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
