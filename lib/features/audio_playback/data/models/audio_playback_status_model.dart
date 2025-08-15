import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';

class AudioPlaybackStatusModel extends AudioPlaybackStatus {
  const AudioPlaybackStatusModel({
    required super.fileName,
    required super.playerState,
    required super.progressDuration,
  });

  factory AudioPlaybackStatusModel.fromMap(Map<String, dynamic> data) {
    final state =
        {
          'playing': AudioPlayerState.playing,
          'paused': AudioPlayerState.paused,
        }[data['state']] ??
        AudioPlayerState.stopped;

    return AudioPlaybackStatusModel(
      fileName: data['fileName'],
      playerState: state,
      progressDuration: Duration(seconds: data['position']),
    );
  }
}
