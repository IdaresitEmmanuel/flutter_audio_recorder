import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_icon.dart';
import 'package:audiorecorder/core/presentation/widgets/app_ink_well.dart';
import 'package:audiorecorder/core/presentation/widgets/gradient_box_border.dart';
import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, required this.isPlaying, this.onTap});
  final bool isPlaying;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Color(0xffE5E7EB).withValues(alpha: .45),
          shape: BoxShape.circle,
          border: GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffFFFFFF).withValues(alpha: .3),
                Color(0xff999999).withValues(alpha: .05),
              ],
            ),
          ),
        ),
        child: Center(
          child: AppIcon(
            isPlaying ? AppAssets.icons.pause : AppAssets.icons.play,
            size: Size(14, 14),
            color: AppColors.grey500,
          ),
        ),
      ),
    );
  }
}
