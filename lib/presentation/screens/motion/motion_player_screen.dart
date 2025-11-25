import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/motion_model.dart';
import '../../widgets/common/custom_button.dart';

class MotionPlayerScreen extends StatefulWidget {
  const MotionPlayerScreen({super.key});

  @override
  State<MotionPlayerScreen> createState() => _MotionPlayerScreenState();
}

class _MotionPlayerScreenState extends State<MotionPlayerScreen> {
  late MotionModel motion;
  bool isPlaying = false;
  bool showControls = true;

  @override
  void initState() {
    super.initState();
    motion = Get.arguments as MotionModel;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Stack(
          children: [
            // 영상 (여기서는 이미지로 대체)
            Center(
              child: CachedNetworkImage(
                imageUrl: motion.thumbnailUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // 오버레이
            if (showControls) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // 상단 바
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      Text(
                        motion.title,
                        style: AppTextStyles.headline4.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () => _showSettingsSheet(),
                      ),
                    ],
                  ),
                ),
              ),
              // 재생 버튼
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              // 하단 컨트롤
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      children: [
                        // 진행바
                        Row(
                          children: [
                            Text(
                              '0:00',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: 0,
                                onChanged: (value) {},
                                activeColor: AppColors.primary,
                                inactiveColor: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              motion.durationText,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: AppSizes.lg),
                            IconButton(
                              icon: const Icon(
                                Icons.forward_10,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: AppSizes.lg),
                            IconButton(
                              icon: const Icon(
                                Icons.repeat,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: AppSizes.lg),
                            IconButton(
                              icon: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('재생 속도', style: AppTextStyles.headline4),
            const SizedBox(height: AppSizes.md),
            Wrap(
              spacing: AppSizes.sm,
              children: ['0.5x', '0.75x', '1x', '1.25x', '1.5x']
                  .map(
                    (speed) => ChoiceChip(
                      label: Text(speed),
                      selected: speed == '1x',
                      onSelected: (selected) {},
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSizes.lg),
            CustomButton(
              text: '닫기',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
