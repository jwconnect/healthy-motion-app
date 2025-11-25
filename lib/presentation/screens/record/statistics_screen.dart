import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/record_controller.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

class StatisticsScreen extends GetView<RecordController> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '통계'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final stats = controller.statistics.value;
        if (stats == null) {
          return const Center(child: Text('통계를 불러올 수 없습니다'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 요약 카드
              _buildSummaryCards(stats),
              const SizedBox(height: AppSizes.lg),
              // 주간 운동 차트
              Text('주간 운동 시간', style: AppTextStyles.headline4),
              const SizedBox(height: AppSizes.md),
              _buildWeeklyChart(stats),
              const SizedBox(height: AppSizes.lg),
              // 연속 기록
              _buildStreakCard(stats),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '이번 주',
            '${stats.weeklyExerciseCount}회',
            Icons.calendar_today,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatCard(
            '이번 달',
            '${stats.monthlyExerciseCount}회',
            Icons.date_range,
            AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppSizes.sm),
          Text(value, style: AppTextStyles.headline2.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(stats) {
    final weeklyMinutes = stats.weeklyMinutes.isNotEmpty
        ? stats.weeklyMinutes
        : [0, 0, 0, 0, 0, 0, 0];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (weeklyMinutes.reduce((a, b) => a > b ? a : b) + 10).toDouble(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final days = ['월', '화', '수', '목', '금', '토', '일'];
                return BarTooltipItem(
                  '${days[groupIndex]}: ${rod.toY.toInt()}분',
                  AppTextStyles.labelMedium.copyWith(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['월', '화', '수', '목', '금', '토', '일'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: AppTextStyles.caption,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            7,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: weeklyMinutes[index].toDouble(),
                  color: AppColors.primary,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(stats) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.red.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '연속 ${stats.streakDays}일',
                  style: AppTextStyles.headline2.copyWith(color: Colors.white),
                ),
                Text(
                  '최장 기록: ${stats.longestStreak}일',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
