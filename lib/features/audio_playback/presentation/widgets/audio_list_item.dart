import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:audiorecorder/core/presentation/widgets/gradient_box_border.dart';
import 'package:audiorecorder/core/util/helper_functions.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/play_pause_button.dart';
import 'package:audiorecorder/features/audio_playback/presentation/widgets/progress_slider.dart';
import 'package:flutter/material.dart';

class AudioListItem extends StatelessWidget {
  const AudioListItem({
    super.key,
    required this.audioFile,
    required this.audioPlaybackStatus,
    this.onLongPress,
    this.onPlayToggle,
    this.seek,
  });
  final AudioFile audioFile;
  final AudioPlaybackStatus? audioPlaybackStatus;
  final void Function(LongPressStartDetails)? onLongPress;
  final void Function()? onPlayToggle;
  final void Function(Duration position)? seek;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: onLongPress,
      child: Container(
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audioFile.title,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        audioPlaybackStatus != null
                            ? calculateAndFormatDuration(
                                audioPlaybackStatus!.progressDuration,
                                false,
                              )
                            : formatDateTime(audioFile.createdAt),
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
                    PlayPauseButton(
                      isPlaying:
                          audioPlaybackStatus?.playerState ==
                          AudioPlayerState.playing,
                      onTap: onPlayToggle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      calculateAndFormatDuration(audioFile.duration, false),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (audioPlaybackStatus != null)
              PlayerSlider(
                min: 0,
                max: audioFile.duration.inSeconds.toDouble(),
                value:
                    audioPlaybackStatus?.progressDuration.inSeconds
                        .toDouble() ??
                    0,
                seek: (position) {
                  if (seek == null) return;
                  seek!(Duration(seconds: position.toInt()));
                },
              ),
          ],
        ),
      ),
    );
  }
}
