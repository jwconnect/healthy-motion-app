import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  Future<AnalyticsService> init() async {
    return this;
  }

  void logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) {
    // 실제 구현에서는 Firebase Analytics 등 사용
    print('Analytics Event: $name, params: $parameters');
  }

  void logScreenView({required String screenName}) {
    logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
  }

  void logMotionView(String motionId, String motionTitle) {
    logEvent(
      name: 'motion_view',
      parameters: {
        'motion_id': motionId,
        'motion_title': motionTitle,
      },
    );
  }

  void logMotionComplete(String motionId, int durationSeconds) {
    logEvent(
      name: 'motion_complete',
      parameters: {
        'motion_id': motionId,
        'duration_seconds': durationSeconds,
      },
    );
  }

  void logRoutineStart(String routineId, String routineTitle) {
    logEvent(
      name: 'routine_start',
      parameters: {
        'routine_id': routineId,
        'routine_title': routineTitle,
      },
    );
  }

  void logRoutineComplete(String routineId, int durationSeconds) {
    logEvent(
      name: 'routine_complete',
      parameters: {
        'routine_id': routineId,
        'duration_seconds': durationSeconds,
      },
    );
  }

  void logPostCreate(String category) {
    logEvent(
      name: 'post_create',
      parameters: {'category': category},
    );
  }

  void logSearch(String query) {
    logEvent(
      name: 'search',
      parameters: {'query': query},
    );
  }

  void logSignUp(String method) {
    logEvent(
      name: 'sign_up',
      parameters: {'method': method},
    );
  }

  void logLogin(String method) {
    logEvent(
      name: 'login',
      parameters: {'method': method},
    );
  }
}
