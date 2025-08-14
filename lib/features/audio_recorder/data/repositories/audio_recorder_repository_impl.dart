import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/audio_recorder_service.dart';
import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_pcm_model.dart';
import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_status_model.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:dartz/dartz.dart';

class AudioRecorderRepositoryImpl implements AudioRecorderRepository {
  final IAudioRecorderService _audioRecorderService;
  AudioRecorderRepositoryImpl(this._audioRecorderService);

  @override
  Future<DataState<Unit>> requestPermission() async {
    try {
      final result = await _audioRecorderService.requestPermission();
      if (result != null && result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to setup recorder'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> startRecording() async {
    try {
      final result = await _audioRecorderService.startRecording();
      if (result != null && result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to start recorder'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> pause() async {
    try {
      final result = await _audioRecorderService.pause();
      if (result != null && result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to pause recorder'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> resume() async {
    try {
      final result = await _audioRecorderService.resume();
      if (result != null && result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to resume recorder'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> stop() async {
    try {
      final result = await _audioRecorderService.stop();
      if (result != null && result) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'Unable to stop recorder'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Stream<AudioRecorderPcmModel> pcmStream() {
    return _audioRecorderService
        .pcmStream()
        .where((data) => data != null)
        .map((data) => AudioRecorderPcmModel.fromMap(data!));
  }

  @override
  Stream<AudioRecorderStatusModel> statusStream() {
    return _audioRecorderService
        .statusStream()
        .where((data) => data != null)
        .map((data) => AudioRecorderStatusModel.fromMap(data!));
  }
}
