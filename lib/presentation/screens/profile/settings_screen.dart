import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_app_bar.dart';

class SettingsScreen extends GetView<ProfileController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '설정'),
      body: ListView(
        children: [
          const _SectionHeader(title: '앱 설정'),
          Obx(() => SwitchListTile(
                title: const Text('다크 모드'),
                subtitle: const Text('어두운 테마를 사용합니다'),
                value: controller.isDarkMode.value,
                onChanged: (value) => controller.toggleDarkMode(),
              )),
          Obx(() => SwitchListTile(
                title: const Text('푸시 알림'),
                subtitle: const Text('알림을 받습니다'),
                value: controller.isNotificationEnabled.value,
                onChanged: (value) => controller.toggleNotification(),
              )),
          Obx(() => SwitchListTile(
                title: const Text('영상 자동 재생'),
                subtitle: const Text('Wi-Fi 연결 시 자동 재생'),
                value: controller.isAutoPlayVideo.value,
                onChanged: (value) => controller.toggleAutoPlayVideo(),
              )),
          const _SectionHeader(title: '데이터'),
          ListTile(
            title: const Text('캐시 삭제'),
            subtitle: const Text('임시 저장된 데이터를 삭제합니다'),
            trailing: const Icon(Icons.chevron_right),
            onTap: controller.clearCache,
          ),
          const _SectionHeader(title: '계정'),
          ListTile(
            title: const Text('비밀번호 변경'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              '회원 탈퇴',
              style: TextStyle(color: AppColors.error),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
            onTap: () {
              Get.find<AuthController>().deleteAccount();
            },
          ),
          const SizedBox(height: AppSizes.xl),
          // 버전 정보
          Center(
            child: Text(
              '버전 1.0.0',
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.lg,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
