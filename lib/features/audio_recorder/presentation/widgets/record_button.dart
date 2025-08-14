import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/widgets/app_icon.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key, required this.isPaused, this.onTap});
  final bool isPaused;
  final void Function()? onTap;
  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  double smallSize = 85;
  double bigSize = 102;
  bool isPaused = false;

  Duration get forwardDuration => Duration(milliseconds: 300);
  Duration get reverseDuration => Duration(milliseconds: 300);

  Curve get animationCurve => Curves.easeInOut;

  _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void initState() {
    isPaused = widget.isPaused;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RecordButton oldWidget) {
    setState(() {
      isPaused = widget.isPaused;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        height: bigSize,
        width: bigSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              height: isPaused ? bigSize : smallSize,
              width: isPaused ? bigSize : smallSize,
              duration: forwardDuration,
              curve: animationCurve,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
            ),
            AnimatedContainer(
              height: isPaused ? smallSize : bigSize,
              width: isPaused ? smallSize : bigSize,
              duration: forwardDuration,

              // curve: animationCurve,
              decoration: BoxDecoration(
                color: isPaused ? AppColors.primary : AppColors.grey800,
                shape: BoxShape.circle,
              ),
            ),
            AnimatedOpacity(
              opacity: isPaused ? 0 : 1,
              duration: forwardDuration,
              curve: animationCurve,
              child: AppIcon(
                AppAssets.icons.pause,
                color: AppColors.grey50,
                size: Size(44, 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
