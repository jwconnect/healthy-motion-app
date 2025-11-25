import 'package:get/get.dart';
import '../../data/models/motion_model.dart';
import '../../data/models/routine_model.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/motion_repository.dart';
import '../../data/repositories/routine_repository.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/auth_repository.dart';

class HomeController extends GetxController {
  final MotionRepository _motionRepository = Get.find<MotionRepository>();
  final RoutineRepository _routineRepository = Get.find<RoutineRepository>();
  final CommunityRepository _communityRepository = Get.find<CommunityRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final recommendedMotions = <MotionModel>[].obs;
  final recentRoutines = <RoutineModel>[].obs;
  final popularPosts = <PostModel>[].obs;
  final isLoading = false.obs;

  final currentTabIndex = 0.obs;

  String get userNickname => _authRepository.currentUser?.nickname ?? '사용자';

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchRecommendedMotions(),
        _fetchRecentRoutines(),
        _fetchPopularPosts(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchRecommendedMotions() async {
    try {
      final result = await _motionRepository.getRecommendedMotions();
      recommendedMotions.assignAll(result);
    } catch (e) {
      // 조용히 처리
    }
  }

  Future<void> _fetchRecentRoutines() async {
    try {
      final userRoutines = await _routineRepository.getUserRoutines();
      final officialRoutines = await _routineRepository.getOfficialRoutines();
      final allRoutines = [...userRoutines, ...officialRoutines];
      allRoutines.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      recentRoutines.assignAll(allRoutines.take(3).toList());
    } catch (e) {
      // 조용히 처리
    }
  }

  Future<void> _fetchPopularPosts() async {
    try {
      final result = await _communityRepository.getPopularPosts(limit: 3);
      popularPosts.assignAll(result);
    } catch (e) {
      // 조용히 처리
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> refresh() async {
    await fetchHomeData();
  }
}
