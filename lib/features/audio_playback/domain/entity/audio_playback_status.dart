import 'package:equatable/equatable.dart';

class AudioPlaybackStatus extends Equatable {
  final String fileName;
  final AudioPlayerState playerState;
  final Duration progressDuration;

  const AudioPlaybackStatus({
    required this.fileName,
    required this.playerState,
    required this.progressDuration,
  });

  @override
  List<Object?> get props => [fileName, playerState, progressDuration];
}

enum AudioPlayerState {
  playing, paused, stopped
}