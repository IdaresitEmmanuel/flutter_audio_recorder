import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';

abstract class AudioPlaybackEvent {}

class RequestStoragePermission extends AudioPlaybackEvent {}

class GetAudioFiles extends AudioPlaybackEvent {}

class DeleteAudioFile extends AudioPlaybackEvent {
  final AudioFile audioFile;
  DeleteAudioFile({required this.audioFile});
}
