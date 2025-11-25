class RecordModel {
  final String id;
  final String userId;
  final String? routineId;
  final String? motionId;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationSeconds;
  final bool isCompleted;
  final String? routineTitle;
  final String? motionTitle;

  RecordModel({
    required this.id,
    required this.userId,
    this.routineId,
    this.motionId,
    required this.startedAt,
    required this.completedAt,
    required this.durationSeconds,
    this.isCompleted = true,
    this.routineTitle,
    this.motionTitle,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routineId: json['routineId'] as String?,
      motionId: json['motionId'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      durationSeconds: json['durationSeconds'] as int,
      isCompleted: json['isCompleted'] as bool? ?? true,
      routineTitle: json['routineTitle'] as String?,
      motionTitle: json['motionTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routineId': routineId,
      'motionId': motionId,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
      'isCompleted': isCompleted,
      'routineTitle': routineTitle,
      'motionTitle': motionTitle,
    };
  }

  RecordModel copyWith({
    String? id,
    String? userId,
    String? routineId,
    String? motionId,
    DateTime? startedAt,
    DateTime? completedAt,
    int? durationSeconds,
    bool? isCompleted,
    String? routineTitle,
    String? motionTitle,
  }) {
    return RecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      routineId: routineId ?? this.routineId,
      motionId: motionId ?? this.motionId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      routineTitle: routineTitle ?? this.routineTitle,
      motionTitle: motionTitle ?? this.motionTitle,
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

  String get title => routineTitle ?? motionTitle ?? '운동 기록';

  bool get isRoutine => routineId != null;
  bool get isMotion => motionId != null && routineId == null;
}

class DailyRecord {
  final DateTime date;
  final List<RecordModel> records;
  final int totalDurationSeconds;
  final int exerciseCount;

  DailyRecord({
    required this.date,
    required this.records,
    required this.totalDurationSeconds,
    required this.exerciseCount,
  });

  factory DailyRecord.fromRecords(DateTime date, List<RecordModel> records) {
    final totalDuration =
        records.fold<int>(0, (sum, record) => sum + record.durationSeconds);
    return DailyRecord(
      date: date,
      records: records,
      totalDurationSeconds: totalDuration,
      exerciseCount: records.length,
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
}

class ExerciseStatistics {
  final int totalExerciseMinutes;
  final int weeklyExerciseCount;
  final int monthlyExerciseCount;
  final int streakDays;
  final int longestStreak;
  final Map<String, int> bodyPartStats;
  final List<int> weeklyMinutes;

  ExerciseStatistics({
    this.totalExerciseMinutes = 0,
    this.weeklyExerciseCount = 0,
    this.monthlyExerciseCount = 0,
    this.streakDays = 0,
    this.longestStreak = 0,
    this.bodyPartStats = const {},
    this.weeklyMinutes = const [],
  });

  factory ExerciseStatistics.fromJson(Map<String, dynamic> json) {
    return ExerciseStatistics(
      totalExerciseMinutes: json['totalExerciseMinutes'] as int? ?? 0,
      weeklyExerciseCount: json['weeklyExerciseCount'] as int? ?? 0,
      monthlyExerciseCount: json['monthlyExerciseCount'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      bodyPartStats: (json['bodyPartStats'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
      weeklyMinutes: (json['weeklyMinutes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  String get totalExerciseText {
    final hours = totalExerciseMinutes ~/ 60;
    final minutes = totalExerciseMinutes % 60;
    if (hours > 0) {
      return minutes > 0 ? '$hours시간 $minutes분' : '$hours시간';
    }
    return '$minutes분';
  }
}
