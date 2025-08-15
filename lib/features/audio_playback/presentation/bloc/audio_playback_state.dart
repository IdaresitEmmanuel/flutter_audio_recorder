import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlaybackState extends Equatable {}

class AudioPlaybackLoading extends AudioPlaybackState {
  @override
  List<Object?> get props => [];
}

class AudioPlaybackDone extends AudioPlaybackState {
  final List<AudioFile> fileList;
  final AudioPlaybackStatus status;
  AudioPlaybackDone({required this.fileList, required this.status});

  AudioPlaybackDone copyWith({
    List<AudioFile>? fileList,
    AudioPlaybackStatus? status,
  }) {
    return AudioPlaybackDone(
      fileList: fileList ?? this.fileList,
      status: status ?? this.status,
    );
  }

  factory AudioPlaybackDone.initial() => AudioPlaybackDone(
    fileList: [],
    status: AudioPlaybackStatus(
      fileName: '',
      playerState: AudioPlayerState.stopped,
      progressDuration: Duration.zero,
    ),
  );

  @override
  List<Object?> get props => [fileList, status];
}
