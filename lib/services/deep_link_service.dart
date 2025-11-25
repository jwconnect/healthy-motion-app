import 'package:get/get.dart';
import '../routes/app_routes.dart';

class DeepLinkService extends GetxService {
  Future<DeepLinkService> init() async {
    return this;
  }

  void handleDeepLink(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;

    switch (path) {
      case '/motion':
        final motionId = queryParams['id'];
        if (motionId != null) {
          Get.toNamed(AppRoutes.motionDetail, arguments: {'id': motionId});
        }
        break;

      case '/routine':
        final routineId = queryParams['id'];
        if (routineId != null) {
          Get.toNamed(AppRoutes.routineDetail, arguments: {'id': routineId});
        }
        break;

      case '/post':
        final postId = queryParams['id'];
        if (postId != null) {
          Get.toNamed(AppRoutes.postDetail, arguments: {'id': postId});
        }
        break;

      case '/user':
        final userId = queryParams['id'];
        if (userId != null) {
          Get.toNamed(AppRoutes.userProfile, arguments: {'id': userId});
        }
        break;

      default:
        // 기본 처리
        break;
    }
  }

  String generateMotionLink(String motionId) {
    return 'https://healthymotion.app/motion?id=$motionId';
  }

  String generateRoutineLink(String routineId) {
    return 'https://healthymotion.app/routine?id=$routineId';
  }

  String generatePostLink(String postId) {
    return 'https://healthymotion.app/post?id=$postId';
  }

  String generateUserLink(String userId) {
    return 'https://healthymotion.app/user?id=$userId';
  }
}
