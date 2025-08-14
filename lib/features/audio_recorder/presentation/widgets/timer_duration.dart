import 'package:audiorecorder/core/presentation/theme/colors.dart';
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
          // width: 218,
          child: Text(
            calculateAndFormatDuration(duration),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ],
    );
  }

  String calculateAndFormatDuration(Duration recordDuration) {
    var seconds = recordDuration.inSeconds;

    int hours = (seconds / (60 * 60)).floor();
    int minutes = (seconds / 60).floor();
    int remSeconds = (seconds % 60);

    String hoursText = hours < 10 ? "0$hours" : "$hours";
    String minutesText = minutes < 10 ? "0$minutes" : "$minutes";
    String remSecondsText = remSeconds < 10 ? "0$remSeconds" : "$remSeconds";
    return "$hoursText:$minutesText:$remSecondsText";
  }
}
