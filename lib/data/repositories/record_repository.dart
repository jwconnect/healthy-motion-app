import '../models/record_model.dart';

class RecordRepository {
  final List<RecordModel> _records = [];

  Future<List<RecordModel>> getRecords({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var result = List<RecordModel>.from(_records);

    if (startDate != null) {
      result = result.where((r) => r.completedAt.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      result = result.where((r) => r.completedAt.isBefore(endDate)).toList();
    }

    result.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return result;
  }

  Future<List<RecordModel>> getRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _records
        .where((r) =>
            r.completedAt.isAfter(startOfDay) &&
            r.completedAt.isBefore(endOfDay))
        .toList();
  }

  Future<RecordModel> createRecord({
    String? routineId,
    String? motionId,
    required DateTime startedAt,
    required DateTime completedAt,
    required int durationSeconds,
    String? routineTitle,
    String? motionTitle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final record = RecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      routineId: routineId,
      motionId: motionId,
      startedAt: startedAt,
      completedAt: completedAt,
      durationSeconds: durationSeconds,
      isCompleted: true,
      routineTitle: routineTitle,
      motionTitle: motionTitle,
    );

    _records.add(record);
    return record;
  }

  Future<ExerciseStatistics> getStatistics() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    final weeklyRecords = _records
        .where((r) => r.completedAt.isAfter(startOfWeek))
        .toList();
    final monthlyRecords = _records
        .where((r) => r.completedAt.isAfter(startOfMonth))
        .toList();

    final totalMinutes =
        _records.fold<int>(0, (sum, r) => sum + r.durationSeconds) ~/ 60;
    final weeklyMinutes = weeklyRecords
        .fold<int>(0, (sum, r) => sum + r.durationSeconds) ~/ 60;

    // 주간 운동 시간 (일별)
    final List<int> weeklyMinutesList = List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      final dayRecords = _records.where((r) =>
          r.completedAt.year == day.year &&
          r.completedAt.month == day.month &&
          r.completedAt.day == day.day);
      return dayRecords.fold<int>(0, (sum, r) => sum + r.durationSeconds) ~/ 60;
    });

    return ExerciseStatistics(
      totalExerciseMinutes: totalMinutes,
      weeklyExerciseCount: weeklyRecords.length,
      monthlyExerciseCount: monthlyRecords.length,
      streakDays: _calculateStreak(),
      longestStreak: _calculateLongestStreak(),
      bodyPartStats: {},
      weeklyMinutes: weeklyMinutesList,
    );
  }

  int _calculateStreak() {
    if (_records.isEmpty) return 0;

    final sortedRecords = List<RecordModel>.from(_records)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    int streak = 0;
    DateTime? lastDate;

    for (final record in sortedRecords) {
      final recordDate = DateTime(
        record.completedAt.year,
        record.completedAt.month,
        record.completedAt.day,
      );

      if (lastDate == null) {
        final today = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
        if (recordDate == today ||
            recordDate == today.subtract(const Duration(days: 1))) {
          streak = 1;
          lastDate = recordDate;
        } else {
          break;
        }
      } else {
        final expectedDate = lastDate.subtract(const Duration(days: 1));
        if (recordDate == expectedDate) {
          streak++;
          lastDate = recordDate;
        } else if (recordDate != lastDate) {
          break;
        }
      }
    }

    return streak;
  }

  int _calculateLongestStreak() {
    if (_records.isEmpty) return 0;

    final dates = _records
        .map((r) => DateTime(
              r.completedAt.year,
              r.completedAt.month,
              r.completedAt.day,
            ))
        .toSet()
        .toList()
      ..sort();

    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  Future<Map<DateTime, List<RecordModel>>> getMonthlyRecords(
    int year,
    int month,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final Map<DateTime, List<RecordModel>> result = {};

    final monthRecords = _records.where((r) =>
        r.completedAt.year == year && r.completedAt.month == month);

    for (final record in monthRecords) {
      final date = DateTime(
        record.completedAt.year,
        record.completedAt.month,
        record.completedAt.day,
      );
      result.putIfAbsent(date, () => []).add(record);
    }

    return result;
  }
}
