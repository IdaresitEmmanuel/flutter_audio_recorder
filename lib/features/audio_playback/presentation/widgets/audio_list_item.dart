import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:audiorecorder/core/presentation/widgets/gradient_box_border.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/play_pause_button.dart';
import 'package:flutter/material.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xffB2B2B2).withValues(alpha: .3),
              Color(0xffB2B2B2).withValues(alpha: .05),
            ],
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Record 01", style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  "Today 14:35",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlayPauseButton(isPlaying: false),
              const SizedBox(height: 4),
              Text(
                "06:25",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
