import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/local_storage.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/motion_repository.dart';
import 'data/repositories/routine_repository.dart';
import 'data/repositories/record_repository.dart';
import 'data/repositories/community_repository.dart';
import 'services/notification_service.dart';
import 'services/analytics_service.dart';
import 'services/deep_link_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 시스템 UI 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 화면 방향 고정 (세로 모드)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 의존성 초기화
  await _initDependencies();

  runApp(const HealthyMotionApp());
}

/// 앱 의존성 초기화
Future<void> _initDependencies() async {
  // Local Storage 초기화
  final localStorage = LocalStorage();
  await localStorage.init();
  Get.put<LocalStorage>(localStorage, permanent: true);

  // Repositories 등록
  Get.put<AuthRepository>(AuthRepository(), permanent: true);
  Get.put<MotionRepository>(MotionRepository(), permanent: true);
  Get.put<RoutineRepository>(RoutineRepository(), permanent: true);
  Get.put<RecordRepository>(RecordRepository(), permanent: true);
  Get.put<CommunityRepository>(CommunityRepository(), permanent: true);

  // Services 등록
  Get.put<NotificationService>(NotificationService(), permanent: true);
  Get.put<AnalyticsService>(AnalyticsService(), permanent: true);
  Get.put<DeepLinkService>(DeepLinkService(), permanent: true);

  // AuthController 등록 (전역에서 필요)
  Get.put<AuthController>(AuthController(), permanent: true);
}

class HealthyMotionApp extends StatelessWidget {
  const HealthyMotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '건강한 동작',
      debugShowCheckedModeBanner: false,

      // 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // 라우트 설정
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      // 로케일 설정
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),

      // 기본 트랜지션
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // 에러 처리
      builder: (context, child) {
        // 텍스트 스케일 제한 (접근성)
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
