import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/home_controller.dart';
import 'home_screen.dart';
import '../motion/motion_list_screen.dart';
import '../routine/routine_list_screen.dart';
import '../community/community_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends GetView<HomeController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentTabIndex.value,
            children: const [
              HomeScreen(),
              MotionListScreen(),
              RoutineListScreen(),
              CommunityScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentTabIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined),
                activeIcon: Icon(Icons.fitness_center),
                label: '동작',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_play_outlined),
                activeIcon: Icon(Icons.playlist_play),
                label: '루틴',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: '커뮤니티',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'MY',
              ),
            ],
          ),
        ));
  }
}
