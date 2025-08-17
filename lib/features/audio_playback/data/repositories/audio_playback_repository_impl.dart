import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_player_service.dart';
import 'package:audiorecorder/features/audio_playback/data/models/audio_playback_status_model.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:dartz/dartz.dart';

class AudioPlaybackRepositoryImpl implements AudioPlaybackRepository {
  final IAudioPlayerService _audioPlayerService;
  AudioPlaybackRepositoryImpl(this._audioPlayerService);

  @override
  Future<DataState<Unit>> play(AudioFile audioFile) async {
    try {
      final result = await _audioPlayerService.play(audioFile);
      if (result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to play audioFile'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> pause() async {
    try {
      final result = await _audioPlayerService.pause();
      if (result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to pause audio'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> seek(Duration seekDuration) async {
    try {
      final result = await _audioPlayerService.seek(seekDuration);
      if (result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to seek new position'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> stop() async {
    try {
      final result = await _audioPlayerService.stop();
      if (result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to pause audio'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Stream<AudioPlaybackStatusModel> playbackStatus() {
    return _audioPlayerService.playbackStatus().map(
      (statusMap) => AudioPlaybackStatusModel.fromMap(statusMap),
    );
  }
}
