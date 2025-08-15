import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:dartz/dartz.dart';

abstract class AudioPlaybackRepository {
  Future<DataState<Unit>> play(AudioFile audioFile);
  Future<DataState<Unit>> pause();
  Future<DataState<Unit>> seek(Duration seekDuration);
  Future<DataState<Unit>> stop();
  Stream<AudioPlaybackStatus> playbackStatus();
}
