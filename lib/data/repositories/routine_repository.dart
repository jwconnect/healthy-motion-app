import '../models/routine_model.dart';
import '../models/motion_model.dart';

class RoutineRepository {
  final List<RoutineModel> _userRoutines = [];

  final List<RoutineModel> _officialRoutines = [
    RoutineModel(
      id: 'official_1',
      userId: 'system',
      title: '아침 스트레칭 5분',
      description: '하루를 시작하는 가벼운 전신 스트레칭',
      motions: [
        RoutineMotion(
          motionId: '1',
          order: 1,
          restSeconds: 10,
          motion: MotionModel(
            id: '1',
            title: '목 스트레칭',
            description: '오랜 시간 컴퓨터 작업으로 뻣뻣해진 목을 풀어주는 스트레칭입니다.',
            videoUrl: 'https://example.com/video1.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion1/400/300',
            durationSeconds: 60,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
        RoutineMotion(
          motionId: '2',
          order: 2,
          restSeconds: 10,
          motion: MotionModel(
            id: '2',
            title: '어깨 돌리기',
            description: '어깨 관절의 유연성을 높이고 긴장을 풀어주는 운동입니다.',
            videoUrl: 'https://example.com/video2.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion2/400/300',
            durationSeconds: 60,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
        RoutineMotion(
          motionId: '4',
          order: 3,
          restSeconds: 10,
          motion: MotionModel(
            id: '4',
            title: '고양이 자세',
            description: '척추를 유연하게 하고 허리 통증을 완화하는 요가 동작입니다.',
            videoUrl: 'https://example.com/video4.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion4/400/300',
            durationSeconds: 120,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
      ],
      totalDurationSeconds: 300,
      isPublic: true,
      isOfficial: true,
      thumbnailUrl: 'https://picsum.photos/seed/routine1/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    RoutineModel(
      id: 'official_2',
      userId: 'system',
      title: '점심시간 목/어깨 풀기',
      description: '업무 중 뻣뻣해진 목과 어깨를 시원하게',
      motions: [
        RoutineMotion(
          motionId: '1',
          order: 1,
          restSeconds: 10,
          motion: MotionModel(
            id: '1',
            title: '목 스트레칭',
            description: '오랜 시간 컴퓨터 작업으로 뻣뻣해진 목을 풀어주는 스트레칭입니다.',
            videoUrl: 'https://example.com/video1.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion1/400/300',
            durationSeconds: 90,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
        RoutineMotion(
          motionId: '2',
          order: 2,
          restSeconds: 10,
          motion: MotionModel(
            id: '2',
            title: '어깨 돌리기',
            description: '어깨 관절의 유연성을 높이고 긴장을 풀어주는 운동입니다.',
            videoUrl: 'https://example.com/video2.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion2/400/300',
            durationSeconds: 90,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
      ],
      totalDurationSeconds: 200,
      isPublic: true,
      isOfficial: true,
      thumbnailUrl: 'https://picsum.photos/seed/routine2/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    RoutineModel(
      id: 'official_3',
      userId: 'system',
      title: '취침 전 릴렉스',
      description: '편안한 수면을 위한 이완 스트레칭',
      motions: [
        RoutineMotion(
          motionId: '3',
          order: 1,
          restSeconds: 15,
          motion: MotionModel(
            id: '3',
            title: '허리 비틀기',
            description: '허리 근육을 이완시키고 척추의 유연성을 높여줍니다.',
            videoUrl: 'https://example.com/video3.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion3/400/300',
            durationSeconds: 120,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
        RoutineMotion(
          motionId: '4',
          order: 2,
          restSeconds: 15,
          motion: MotionModel(
            id: '4',
            title: '고양이 자세',
            description: '척추를 유연하게 하고 허리 통증을 완화하는 요가 동작입니다.',
            videoUrl: 'https://example.com/video4.mp4',
            thumbnailUrl: 'https://picsum.photos/seed/motion4/400/300',
            durationSeconds: 180,
            difficulty: 'beginner',
            createdAt: DateTime.now(),
          ),
        ),
      ],
      totalDurationSeconds: 330,
      isPublic: true,
      isOfficial: true,
      thumbnailUrl: 'https://picsum.photos/seed/routine3/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  Future<List<RoutineModel>> getUserRoutines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _userRoutines;
  }

  Future<List<RoutineModel>> getOfficialRoutines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _officialRoutines;
  }

  Future<RoutineModel?> getRoutineById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return [..._userRoutines, ..._officialRoutines]
          .firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<RoutineModel> createRoutine({
    required String title,
    String? description,
    required List<RoutineMotion> motions,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final totalDuration =
        motions.fold<int>(0, (sum, m) => sum + (m.motion?.durationSeconds ?? 0) + m.restSeconds);

    final routine = RoutineModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      title: title,
      description: description,
      motions: motions,
      totalDurationSeconds: totalDuration,
      isPublic: false,
      isOfficial: false,
      thumbnailUrl: motions.isNotEmpty ? motions.first.motion?.thumbnailUrl : null,
      createdAt: DateTime.now(),
    );

    _userRoutines.add(routine);
    return routine;
  }

  Future<RoutineModel> updateRoutine(RoutineModel routine) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _userRoutines.indexWhere((r) => r.id == routine.id);
    if (index != -1) {
      _userRoutines[index] = routine.copyWith(updatedAt: DateTime.now());
      return _userRoutines[index];
    }
    throw Exception('루틴을 찾을 수 없습니다');
  }

  Future<void> deleteRoutine(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userRoutines.removeWhere((r) => r.id == id);
  }
}
