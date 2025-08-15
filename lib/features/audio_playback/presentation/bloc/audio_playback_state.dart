import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlaybackState extends Equatable {}

class AudioPlaybackLoading extends AudioPlaybackState {
  @override
  List<Object?> get props => [];
}

class AudioPlaybackDone extends AudioPlaybackState {
  final List<AudioFile> fileList;
  AudioPlaybackDone({required this.fileList});

  AudioPlaybackDone copyWith({List<AudioFile>? fileList}) {
    return AudioPlaybackDone(fileList: fileList ?? this.fileList);
  }

  @override
  List<Object?> get props => [fileList];
}
