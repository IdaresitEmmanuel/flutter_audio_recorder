import 'dart:async';

import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  final StartRecordingUsecase _startRecordingUsecase;
  final PauseRecorderUsecase _pauseRecorderUsecase;
  final ResumeRecorderUsecase _resumeRecorderUsecase;
  final StopRecorderUsecase _stopRecorderUsecase;
  final GetPcmStreamUsecase _pcmStreamUsecase;
  final GetRecorderStatusStreamUsecase _recorderStatusStreamUsecase;
  AudioRecorderBloc(
    this._startRecordingUsecase,
    this._pauseRecorderUsecase,
    this._resumeRecorderUsecase,
    this._stopRecorderUsecase,
    this._pcmStreamUsecase,
    this._recorderStatusStreamUsecase,
  ) : super(AudioRecorderStateActive.initial()) {
    on<StartAudioRecorder>(_onStartAudioRecorder);
    on<PauseAudioRecorder>(_onPauseAudioRecorder);
    on<ResumeAudioRecorder>(_onResumeAudioRecorder);
    on<StopAudioRecorder>(_onStopAudioRecorder);
    on<GetAudioRecorderPcmStream>(_onGetAudioRecorderPcmStream);
    on<GetAudioRecorderStatusStream>(_onGetAudioRecorderStatusStream);
  }

  StreamSubscription? _pcmStreamSubscription;
  StreamSubscription? _statusStreamSubscription;

  @override
  Future<void> close() async {
    _pcmStreamSubscription?.cancel();
    _statusStreamSubscription?.cancel();
    super.close();
  }

  void _onStartAudioRecorder(
    StartAudioRecorder event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _startRecordingUsecase();
    if (result is DataFailure) {
      EchoLogger.e(result.error.toString());
      emit(AudioRecordStateError(error: result.error!));
    } else {
      EchoLogger.i("Recorder Started");
    }
  }

  void _onPauseAudioRecorder(
    PauseAudioRecorder event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _pauseRecorderUsecase();
    if (result is DataSuccess) {
      EchoLogger.i("Recorder Paused");
    } else {
      EchoLogger.e(result.error.toString());
    }
  }

  void _onResumeAudioRecorder(
    ResumeAudioRecorder event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _resumeRecorderUsecase();
    if (result is DataSuccess) {
      EchoLogger.i("Recorder Resumed");
    } else {
      EchoLogger.e(result.error.toString());
    }
  }

  void _onStopAudioRecorder(
    StopAudioRecorder event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _stopRecorderUsecase();
    if (result is DataSuccess) {
      EchoLogger.i("Recorder Stopped");
    } else {
      EchoLogger.e(result.error.toString());
    }
  }

  void _onGetAudioRecorderPcmStream(
    GetAudioRecorderPcmStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    _pcmStreamSubscription?.cancel();
    _pcmStreamSubscription = _pcmStreamUsecase().listen((pcm) {
      final newState = state is AudioRecorderStateActive
          ? (state as AudioRecorderStateActive).copyWith(
              pcm: [...(state as AudioRecorderStateActive).pcm, pcm],
            )
          : AudioRecorderStateActive(
              recorderStatus: AudioRecorderStatus(
                isRecording: true,
                recordDuration: pcm.timestamp,
              ),
              pcm: [pcm],
            );
      emit(newState);
    });
  }

  void _onGetAudioRecorderStatusStream(
    GetAudioRecorderStatusStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    _pcmStreamSubscription?.cancel();
    _pcmStreamSubscription = _recorderStatusStreamUsecase().listen((status) {
      final newState = state is AudioRecorderStateActive
          ? (state as AudioRecorderStateActive).copyWith(recorderStatus: status)
          : AudioRecorderStateActive(recorderStatus: status, pcm: []);
      emit(newState);
    });
  }
}
