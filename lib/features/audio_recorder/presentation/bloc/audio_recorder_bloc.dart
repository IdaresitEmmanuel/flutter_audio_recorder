import 'dart:async';

import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  final RequestRecordPermissionUsecase _recordPermissionUsecase;
  final StartRecordingUsecase _startRecordingUsecase;
  final PauseRecorderUsecase _pauseRecorderUsecase;
  final ResumeRecorderUsecase _resumeRecorderUsecase;
  final StopRecorderUsecase _stopRecorderUsecase;
  final GetPcmStreamUsecase _pcmStreamUsecase;
  final GetRecorderStatusStreamUsecase _recorderStatusStreamUsecase;
  AudioRecorderBloc(
    this._recordPermissionUsecase,
    this._startRecordingUsecase,
    this._pauseRecorderUsecase,
    this._resumeRecorderUsecase,
    this._stopRecorderUsecase,
    this._pcmStreamUsecase,
    this._recorderStatusStreamUsecase,
  ) : super(AudioRecorderStateActive.initial()) {
    on<RequestRecordPermission>(_onRequestRecordPermission);
    on<StartAudioRecorder>(_onStartAudioRecorder);
    on<PauseAudioRecorder>(_onPauseAudioRecorder);
    on<ResumeAudioRecorder>(_onResumeAudioRecorder);
    on<StopAudioRecorder>(_onStopAudioRecorder);
    on<GetAudioRecorderPcmStream>(_onGetAudioRecorderPcmStream);
    on<GetAudioRecorderStatusStream>(_onGetAudioRecorderStatusStream);
  }

  StreamSubscription? _pcmStreamSubscription;
  Timer? pcmSmoothTimer;
 BehaviorSubject<List<AudioRecorderPcm>> pcmStreamController =
      BehaviorSubject.seeded([], sync: true);
  // final StreamController<List<AudioRecorderPcm>> pcmStreamController =
  //     StreamController();
  List<AudioRecorderPcm> pcmBuffer = [];

  init() async {
    _startSmoothPcm();
    add(GetAudioRecorderPcmStream());
    add(GetAudioRecorderStatusStream());
  }

  @override
  Future<void> close() {
    pcmSmoothTimer?.cancel();
    pcmStreamController.close();
    _pcmStreamSubscription?.cancel();
    pcmBuffer.clear();
    return super.close();
  }

  Future<void> _onRequestRecordPermission(
    RequestRecordPermission event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _recordPermissionUsecase();
    if (result is DataFailure) {
      EchoLogger.e(result.error.toString());
      // return true;
    } else {
      EchoLogger.i("Recorder Started");
      // return false;
    }
  }

  void _onStartAudioRecorder(
    StartAudioRecorder event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final hasPermissionState = await _recordPermissionUsecase();
    if (hasPermissionState is DataFailure) return;
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

  _startSmoothPcm() async {
    _pcmStreamSubscription?.cancel();
    pcmSmoothTimer = Timer.periodic(const Duration(microseconds: 100), (timer) {
      pcmStreamController.add(pcmBuffer);
    });
  }

  void _onGetAudioRecorderPcmStream(
    GetAudioRecorderPcmStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    // Use await for to process each item from the stream.
    // The event handler will wait here until the stream closes.
    await for (final pcm in _pcmStreamUsecase()) {
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
      pcmBuffer.add(pcm);
      // This emit() call is now safe because the handler is still active.
      // log(pcm.toString());
      emit(newState);
    }
  }

  void _onGetAudioRecorderStatusStream(
    GetAudioRecorderStatusStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    // Use await for to process each item from the stream.
    // This keeps the event handler running until the stream is closed.
    await for (final status in _recorderStatusStreamUsecase()) {
      final newState = state is AudioRecorderStateActive
          ? (state as AudioRecorderStateActive).copyWith(recorderStatus: status)
          : AudioRecorderStateActive(recorderStatus: status, pcm: []);
      // The emit() call is now safe because the handler is still active.
      emit(newState);
    }
  }
}
