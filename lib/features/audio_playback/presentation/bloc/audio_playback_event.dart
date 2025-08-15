import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlaybackEvent extends Equatable{}

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
  List<Object?> get props => [];
}
