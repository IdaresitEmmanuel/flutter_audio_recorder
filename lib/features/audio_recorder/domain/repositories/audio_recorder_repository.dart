import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:dartz/dartz.dart';

abstract class AudioRecorderRepository {
  Future<DataState<Unit>> startRecording();
  Future<DataState<Unit>> pause();
  Future<DataState<Unit>> resume();
  Future<DataState<Unit>> stop();

  Stream<AudioRecorderPcm> pcmStream();
  Stream<AudioRecorderStatus> statusStream();
}
