import 'package:audiorecorder/core/presentation/widgets/app_icon.dart';
import 'package:audiorecorder/core/presentation/widgets/app_ink_well.dart';
import 'package:audiorecorder/core/presentation/widgets/gradient_box_border.dart';
import 'package:flutter/material.dart';

class MediaButton extends StatelessWidget {
  const MediaButton({super.key, required this.assetIconPath, this.onTap});
  final String assetIconPath;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      radius: 36,
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(36),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Color(0xff999999).withValues(alpha: .05),
                Color(0xffFFFFFF).withValues(alpha: .3),
              ],
            ),
            width: 1,
          ),
        ),
        child: Center(child: AppIcon(assetIconPath, size: Size(32, 32))),
      ),
    );
  }
}
