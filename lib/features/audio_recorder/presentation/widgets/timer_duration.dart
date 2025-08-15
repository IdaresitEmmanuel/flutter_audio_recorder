import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/util/helper_functions.dart';
import 'package:flutter/material.dart';

class TimerDuration extends StatelessWidget {
  const TimerDuration({
    super.key,
    required this.duration,
    required this.isRecording,
  });
  final Duration duration;
  final bool isRecording;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: isRecording ? AppColors.primary : Colors.transparent,
        ),
        SizedBox(width: 6),
        SizedBox(
          child: Text(
            calculateAndFormatDuration(duration),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ],
    );
  }

 
}
