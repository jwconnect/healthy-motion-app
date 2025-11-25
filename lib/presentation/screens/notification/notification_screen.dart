import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/notification_model.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/error_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 데모용 알림 데이터
    final notifications = [
      NotificationModel(
        id: '1',
        userId: 'user1',
        type: 'like',
        title: '좋아요',
        body: '운동러버님이 회원님의 게시글을 좋아합니다.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: '2',
        userId: 'user1',
        type: 'comment',
        title: '댓글',
        body: '건강지킴이님이 댓글을 남겼습니다: "대단하세요!"',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '3',
        userId: 'user1',
        type: 'reminder',
        title: '운동 리마인더',
        body: '오늘의 스트레칭을 잊지 마세요!',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      NotificationModel(
        id: '4',
        userId: 'user1',
        type: 'system',
        title: '시스템 알림',
        body: '건강한 동작 앱이 업데이트되었습니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: '알림',
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('모두 읽음'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyWidget(
              message: '알림이 없습니다',
              icon: Icons.notifications_none,
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getIconColor().withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getIcon(),
          color: _getIconColor(),
        ),
      ),
      title: Text(
        notification.title,
        style: AppTextStyles.labelLarge.copyWith(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.body,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            AppDateUtils.formatRelativeTime(notification.createdAt),
            style: AppTextStyles.caption,
          ),
        ],
      ),
      isThreeLine: true,
      tileColor: notification.isRead ? null : AppColors.primaryLight.withOpacity(0.1),
      onTap: () {
        // 알림 처리
      },
    );
  }

  IconData _getIcon() {
    switch (notification.notificationType) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.chat_bubble;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getIconColor() {
    switch (notification.notificationType) {
      case NotificationType.like:
        return AppColors.error;
      case NotificationType.comment:
        return AppColors.secondary;
      case NotificationType.follow:
        return AppColors.primary;
      case NotificationType.reminder:
        return AppColors.warning;
      case NotificationType.system:
        return AppColors.info;
    }
  }
}
