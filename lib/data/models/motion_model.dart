class MotionModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final String difficulty;
  final List<String> bodyParts;
  final List<String> purposes;
  final List<String> steps;
  final List<String> cautions;
  final int likeCount;
  final int viewCount;
  final DateTime createdAt;
  final bool isLiked;

  MotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.difficulty,
    this.bodyParts = const [],
    this.purposes = const [],
    this.steps = const [],
    this.cautions = const [],
    this.likeCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory MotionModel.fromJson(Map<String, dynamic> json) {
    return MotionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      durationSeconds: json['durationSeconds'] as int,
      difficulty: json['difficulty'] as String,
      bodyParts: (json['bodyParts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      purposes: (json['purposes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      cautions: (json['cautions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      likeCount: json['likeCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'difficulty': difficulty,
      'bodyParts': bodyParts,
      'purposes': purposes,
      'steps': steps,
      'cautions': cautions,
      'likeCount': likeCount,
      'viewCount': viewCount,
      'createdAt': createdAt.toIso8601String(),
      'isLiked': isLiked,
    };
  }

  MotionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? durationSeconds,
    String? difficulty,
    List<String>? bodyParts,
    List<String>? purposes,
    List<String>? steps,
    List<String>? cautions,
    int? likeCount,
    int? viewCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return MotionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      difficulty: difficulty ?? this.difficulty,
      bodyParts: bodyParts ?? this.bodyParts,
      purposes: purposes ?? this.purposes,
      steps: steps ?? this.steps,
      cautions: cautions ?? this.cautions,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get durationText {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0) {
      return seconds > 0 ? '$minutes분 $seconds초' : '$minutes분';
    }
    return '$seconds초';
  }

  String get difficultyText {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '초급';
      case 'intermediate':
        return '중급';
      case 'advanced':
        return '고급';
      default:
        return difficulty;
    }
  }
}
