import '../models/motion_model.dart';

class MotionRepository {
  // 데모용 더미 데이터
  final List<MotionModel> _demoMotions = [
    MotionModel(
      id: '1',
      title: '목 스트레칭',
      description: '오랜 시간 컴퓨터 작업으로 뻣뻣해진 목을 풀어주는 스트레칭입니다.',
      videoUrl: 'https://example.com/video1.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion1/400/300',
      durationSeconds: 180,
      difficulty: 'beginner',
      bodyParts: ['neck', 'shoulder'],
      purposes: ['stretching', 'pain_relief'],
      steps: [
        '편안한 자세로 앉습니다',
        '천천히 목을 오른쪽으로 기울입니다',
        '10초간 유지 후 반대쪽으로 반복합니다',
      ],
      cautions: [
        '무리하게 목을 꺾지 마세요',
        '통증이 느껴지면 즉시 중단하세요',
      ],
      likeCount: 128,
      viewCount: 1520,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    MotionModel(
      id: '2',
      title: '어깨 돌리기',
      description: '어깨 관절의 유연성을 높이고 긴장을 풀어주는 운동입니다.',
      videoUrl: 'https://example.com/video2.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion2/400/300',
      durationSeconds: 120,
      difficulty: 'beginner',
      bodyParts: ['shoulder'],
      purposes: ['stretching', 'posture'],
      steps: [
        '양팔을 몸 옆에 자연스럽게 내립니다',
        '어깨를 앞에서 뒤로 크게 돌립니다',
        '10회 반복 후 반대 방향으로 돌립니다',
      ],
      cautions: ['너무 빠르게 돌리지 마세요'],
      likeCount: 95,
      viewCount: 980,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    MotionModel(
      id: '3',
      title: '허리 비틀기',
      description: '허리 근육을 이완시키고 척추의 유연성을 높여줍니다.',
      videoUrl: 'https://example.com/video3.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion3/400/300',
      durationSeconds: 240,
      difficulty: 'intermediate',
      bodyParts: ['back', 'waist'],
      purposes: ['stretching', 'pain_relief'],
      steps: [
        '바닥에 누워 무릎을 세웁니다',
        '양팔을 옆으로 벌립니다',
        '무릎을 오른쪽으로 천천히 내립니다',
        '15초 유지 후 반대쪽으로 반복합니다',
      ],
      cautions: ['허리 디스크가 있는 분은 주의하세요'],
      likeCount: 156,
      viewCount: 2100,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    MotionModel(
      id: '4',
      title: '고양이 자세',
      description: '척추를 유연하게 하고 허리 통증을 완화하는 요가 동작입니다.',
      videoUrl: 'https://example.com/video4.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion4/400/300',
      durationSeconds: 300,
      difficulty: 'beginner',
      bodyParts: ['back', 'full_body'],
      purposes: ['stretching', 'posture', 'relax'],
      steps: [
        '네 발로 엎드린 자세를 취합니다',
        '숨을 내쉬며 등을 둥글게 말아 올립니다',
        '숨을 들이쉬며 등을 아래로 내립니다',
        '10회 반복합니다',
      ],
      cautions: ['무릎에 쿠션을 깔고 하면 더 편안합니다'],
      likeCount: 203,
      viewCount: 3200,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    MotionModel(
      id: '5',
      title: '스쿼트',
      description: '하체 근력을 강화하는 기본 운동입니다.',
      videoUrl: 'https://example.com/video5.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion5/400/300',
      durationSeconds: 600,
      difficulty: 'intermediate',
      bodyParts: ['lower_body'],
      purposes: ['strength'],
      steps: [
        '어깨 너비로 발을 벌리고 섭니다',
        '엉덩이를 뒤로 빼며 앉습니다',
        '무릎이 발끝을 넘지 않도록 합니다',
        '천천히 일어납니다',
        '15회 3세트 반복합니다',
      ],
      cautions: [
        '무릎이 발끝을 넘지 않도록 주의하세요',
        '허리를 곧게 펴세요',
      ],
      likeCount: 312,
      viewCount: 4500,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    MotionModel(
      id: '6',
      title: '플랭크',
      description: '코어 근육을 강화하는 전신 운동입니다.',
      videoUrl: 'https://example.com/video6.mp4',
      thumbnailUrl: 'https://picsum.photos/seed/motion6/400/300',
      durationSeconds: 180,
      difficulty: 'intermediate',
      bodyParts: ['full_body'],
      purposes: ['strength', 'posture'],
      steps: [
        '엎드린 자세에서 팔꿈치로 몸을 지탱합니다',
        '몸을 일직선으로 유지합니다',
        '30초간 유지합니다',
        '3세트 반복합니다',
      ],
      cautions: ['허리가 처지지 않도록 주의하세요'],
      likeCount: 278,
      viewCount: 3800,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  Future<List<MotionModel>> getMotions({
    String? bodyPart,
    String? purpose,
    String? difficulty,
    String? search,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var result = List<MotionModel>.from(_demoMotions);

    if (bodyPart != null && bodyPart.isNotEmpty) {
      result = result.where((m) => m.bodyParts.contains(bodyPart)).toList();
    }
    if (purpose != null && purpose.isNotEmpty) {
      result = result.where((m) => m.purposes.contains(purpose)).toList();
    }
    if (difficulty != null && difficulty.isNotEmpty) {
      result = result.where((m) => m.difficulty == difficulty).toList();
    }
    if (search != null && search.isNotEmpty) {
      result = result
          .where((m) =>
              m.title.toLowerCase().contains(search.toLowerCase()) ||
              m.description.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return result;
  }

  Future<MotionModel?> getMotionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _demoMotions.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<MotionModel>> getRecommendedMotions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoMotions.take(4).toList();
  }

  Future<void> likeMotion(String motionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> unlikeMotion(String motionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> incrementViewCount(String motionId) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
