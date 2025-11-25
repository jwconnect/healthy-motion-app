import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/bindings/auth_binding.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/bindings/motion_binding.dart';
import '../presentation/bindings/routine_binding.dart';
import '../presentation/bindings/community_binding.dart';
import '../presentation/bindings/profile_binding.dart';
import '../presentation/bindings/record_binding.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/main_screen.dart';
import '../presentation/screens/motion/motion_list_screen.dart';
import '../presentation/screens/motion/motion_detail_screen.dart';
import '../presentation/screens/motion/motion_player_screen.dart';
import '../presentation/screens/routine/routine_list_screen.dart';
import '../presentation/screens/routine/routine_create_screen.dart';
import '../presentation/screens/routine/routine_detail_screen.dart';
import '../presentation/screens/routine/routine_player_screen.dart';
import '../presentation/screens/community/community_screen.dart';
import '../presentation/screens/community/post_detail_screen.dart';
import '../presentation/screens/community/post_create_screen.dart';
import '../presentation/screens/community/user_profile_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/edit_profile_screen.dart';
import '../presentation/screens/profile/settings_screen.dart';
import '../presentation/screens/notification/notification_screen.dart';
import '../presentation/screens/record/record_screen.dart';
import '../presentation/screens/record/statistics_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      bindings: [
        HomeBinding(),
        MotionBinding(),
        RoutineBinding(),
        CommunityBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.motionList,
      page: () => const MotionListScreen(),
      binding: MotionBinding(),
    ),
    GetPage(
      name: AppRoutes.motionDetail,
      page: () => const MotionDetailScreen(),
      binding: MotionBinding(),
    ),
    GetPage(
      name: AppRoutes.motionPlayer,
      page: () => const MotionPlayerScreen(),
      binding: MotionBinding(),
    ),
    GetPage(
      name: AppRoutes.routineList,
      page: () => const RoutineListScreen(),
      binding: RoutineBinding(),
    ),
    GetPage(
      name: AppRoutes.routineCreate,
      page: () => const RoutineCreateScreen(),
      binding: RoutineBinding(),
    ),
    GetPage(
      name: AppRoutes.routineDetail,
      page: () => const RoutineDetailScreen(),
      binding: RoutineBinding(),
    ),
    GetPage(
      name: AppRoutes.routinePlayer,
      page: () => const RoutinePlayerScreen(),
      binding: RoutineBinding(),
    ),
    GetPage(
      name: AppRoutes.community,
      page: () => const CommunityScreen(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: AppRoutes.postDetail,
      page: () => const PostDetailScreen(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: AppRoutes.postCreate,
      page: () => const PostCreateScreen(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: AppRoutes.userProfile,
      page: () => const UserProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.records,
      page: () => const RecordScreen(),
      binding: RecordBinding(),
    ),
    GetPage(
      name: AppRoutes.statistics,
      page: () => const StatisticsScreen(),
      binding: RecordBinding(),
    ),
  ];
}
