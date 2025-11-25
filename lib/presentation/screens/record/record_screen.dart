import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/record_controller.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

class RecordScreen extends GetView<RecordController> {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '운동 기록',
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.toNamed(AppRoutes.statistics),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 통계 요약
                _buildStatsSummary(),
                // 캘린더
                _buildCalendar(),
                // 선택된 날짜의 기록
                _buildDailyRecords(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Obx(() {
        final stats = controller.statistics.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              '이번 주',
              '${stats?.weeklyExerciseCount ?? 0}회',
              Icons.fitness_center,
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            _buildStatItem(
              '연속',
              '${stats?.streakDays ?? 0}일',
              Icons.local_fire_department,
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            _buildStatItem(
              '총 운동',
              stats?.totalExerciseText ?? '0분',
              Icons.timer_outlined,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
      child: Obx(() => TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: controller.focusedDate.value,
            selectedDayPredicate: (day) =>
                isSameDay(controller.selectedDate.value, day),
            onDaySelected: (selectedDay, focusedDay) {
              controller.selectDate(selectedDay);
              controller.focusedDate.value = focusedDay;
            },
            onPageChanged: (focusedDay) {
              controller.changeMonth(focusedDay);
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTextStyles.headline4,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (controller.hasRecordOnDate(date)) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            locale: 'ko_KR',
          )),
    );
  }

  Widget _buildDailyRecords() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                AppDateUtils.formatKoreanDate(controller.selectedDate.value),
                style: AppTextStyles.headline4,
              )),
          const SizedBox(height: AppSizes.md),
          Obx(() {
            final records = controller.getRecordsForDate(
              controller.selectedDate.value,
            );

            if (records.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        '이 날의 운동 기록이 없습니다',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: records
                  .map((record) => Card(
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                            ),
                            child: Icon(
                              record.isRoutine
                                  ? Icons.playlist_play
                                  : Icons.fitness_center,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(record.title),
                          subtitle: Text(
                            AppDateUtils.formatTime(record.completedAt),
                          ),
                          trailing: Text(
                            record.durationText,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}
