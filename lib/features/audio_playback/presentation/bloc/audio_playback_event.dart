import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlaybackEvent extends Equatable {}

class RequestStoragePermission extends AudioPlaybackEvent {
  @override
  List<Object?> get props => [];
}

class GetAudioFiles extends AudioPlaybackEvent {
  @override
  List<Object?> get props => [];
}

class DeleteAudioFile extends AudioPlaybackEvent {
  final AudioFile audioFile;
  DeleteAudioFile({required this.audioFile});

  @override
  List<Object?> get props => [audioFile];
}

class PlayAudioFile extends AudioPlaybackEvent {
  final AudioFile audioFile;
  PlayAudioFile({required this.audioFile});

  @override
  List<Object?> get props => [audioFile];
}

class PauseAudioPlayer extends AudioPlaybackEvent {
  PauseAudioPlayer();

  @override
  List<Object?> get props => [];
}

class SeekToPosition extends AudioPlaybackEvent {
  final Duration position;
  SeekToPosition({required this.position});

  @override
  List<Object?> get props => [position];
}

class StopAudioPlayer extends AudioPlaybackEvent {
  StopAudioPlayer();

  @override
  List<Object?> get props => [];
}

class GetAudioPlaybackStatus extends AudioPlaybackEvent {
  GetAudioPlaybackStatus();

  @override
  List<Object?> get props => [];
}
