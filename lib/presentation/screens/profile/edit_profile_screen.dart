import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/community/user_avatar.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '프로필 수정'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.lg),
            // 프로필 이미지
            Center(
              child: Stack(
                children: [
                  Obx(() => UserAvatar(
                        imageUrl: controller.selectedProfileImage.value,
                        size: 100,
                      )),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        // 이미지 선택
                        controller.selectProfileImage(
                          'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/200/200',
                        );
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            // 닉네임
            CustomTextField(
              controller: controller.nicknameController,
              label: '닉네임',
              hint: '닉네임을 입력하세요',
            ),
            const SizedBox(height: AppSizes.md),
            // 소개
            CustomTextField(
              controller: controller.bioController,
              label: '소개',
              hint: '자기소개를 입력하세요',
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.xl),
            // 저장 버튼
            Obx(() => CustomButton(
                  text: '저장',
                  onPressed: controller.updateProfile,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}
