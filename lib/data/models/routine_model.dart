import 'motion_model.dart';

class RoutineModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final List<RoutineMotion> motions;
  final int totalDurationSeconds;
  final bool isPublic;
  final bool isOfficial;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RoutineModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.motions = const [],
    this.totalDurationSeconds = 0,
    this.isPublic = false,
    this.isOfficial = false,
    this.thumbnailUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      motions: (json['motions'] as List<dynamic>?)
              ?.map((e) => RoutineMotion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalDurationSeconds: json['totalDurationSeconds'] as int? ?? 0,
      isPublic: json['isPublic'] as bool? ?? false,
      isOfficial: json['isOfficial'] as bool? ?? false,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'motions': motions.map((e) => e.toJson()).toList(),
      'totalDurationSeconds': totalDurationSeconds,
      'isPublic': isPublic,
      'isOfficial': isOfficial,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  RoutineModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<RoutineMotion>? motions,
    int? totalDurationSeconds,
    bool? isPublic,
    bool? isOfficial,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      motions: motions ?? this.motions,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      isPublic: isPublic ?? this.isPublic,
      isOfficial: isOfficial ?? this.isOfficial,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get totalDurationText {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    if (minutes > 0) {
      return seconds > 0 ? '$minutes분 $seconds초' : '$minutes분';
    }
    return '$seconds초';
  }

  int get motionCount => motions.length;
}

class RoutineMotion {
  final String motionId;
  final int order;
  final int restSeconds;
  final MotionModel? motion;

  RoutineMotion({
    required this.motionId,
    required this.order,
    this.restSeconds = 10,
    this.motion,
  });

  factory RoutineMotion.fromJson(Map<String, dynamic> json) {
    return RoutineMotion(
      motionId: json['motionId'] as String,
      order: json['order'] as int,
      restSeconds: json['restSeconds'] as int? ?? 10,
      motion: json['motion'] != null
          ? MotionModel.fromJson(json['motion'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'motionId': motionId,
      'order': order,
      'restSeconds': restSeconds,
      'motion': motion?.toJson(),
    };
  }

  RoutineMotion copyWith({
    String? motionId,
    int? order,
    int? restSeconds,
    MotionModel? motion,
  }) {
    return RoutineMotion(
      motionId: motionId ?? this.motionId,
      order: order ?? this.order,
      restSeconds: restSeconds ?? this.restSeconds,
      motion: motion ?? this.motion,
    );
  }
}
