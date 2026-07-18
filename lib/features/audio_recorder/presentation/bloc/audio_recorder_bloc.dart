import 'dart:async';

import 'package:audiorecorder/core/presentation/widgets/messenger.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/save_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  final RequestRecordPermissionUsecase _recordPermissionUsecase;
  final StartRecordingUsecase _startRecordingUsecase;
  final PauseRecorderUsecase _pauseRecorderUsecase;
  final ResumeRecorderUsecase _resumeRecorderUsecase;
  final StopRecorderUsecase _stopRecorderUsecase;
  final GetPcmStreamUsecase _pcmStreamUsecase;
  final GetRecorderStatusStreamUsecase _recorderStatusStreamUsecase;
  //
  final SaveRecordingUsecase _saveRecordingUsecase;
  AudioRecorderBloc(
    this._recordPermissionUsecase,
    this._startRecordingUsecase,
    this._pauseRecorderUsecase,
    this._resumeRecorderUsecase,
    this._stopRecorderUsecase,
    this._pcmStreamUsecase,
    this._recorderStatusStreamUsecase,
    this._saveRecordingUsecase,
  ) : super(AudioRecorderStateActive.initial()) {
    on<RequestRecordPermission>(_onRequestRecordPermission);
    on<StartAudioRecorder>(_onStartAudioRecorder);
    on<PauseAudioRecorder>(_onPauseAudioRecorder);
    on<ResumeAudioRecorder>(_onResumeAudioRecorder);
    on<StopAudioRecorder>(_onStopAudioRecorder);
    on<GetAudioRecorderPcmStream>(_onGetAudioRecorderPcmStream);
    on<GetAudioRecorderStatusStream>(_onGetAudioRecorderStatusStream);
    on<SaveAudioRecording>(_onSaveAudioRecording);
    on<DiscardAudioRecording>(_onDiscardAudioRecording);
    on<RestartAudioRecording>(_onRestartAudioRecording);
  }

  // Audio Pcm here to avoid slowing down the UI with too many state updates
  List<AudioRecorderPcm> pcmList = [];
  final pcmStreamController =
      StreamController<List<AudioRecorderPcm>>.broadcast()..add([]);
  Stream<List<AudioRecorderPcm>> get pcmStream => pcmStreamController.stream;

  @override
  Future<void> close() async {
    pcmList.clear();
    pcmStreamController.close();
    await super.close();
  }

  init() async {
    add(GetAudioRecorderPcmStream());
    add(GetAudioRecorderStatusStream());
  }

  // MARK: Request Record Permission
  Future<void> _onRequestRecordPermission(
    RequestRecordPermission event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final result = await _recordPermissionUsecase();
    if (result is DataFailure) {
      EchoLogger.e(result.error.toString());
    } else {
      EchoLogger.i("Recorder Started");
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

  void _onGetAudioRecorderPcmStream(
    GetAudioRecorderPcmStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    // Await stream for safe emit call
    // because emitter becomes invalid when this function returns
    await for (final pcm in _pcmStreamUsecase()) {
      final newState = state is AudioRecorderStateActive
          ? (state as AudioRecorderStateActive).copyWith(
              // pcm: [...(state as AudioRecorderStateActive).pcm, pcm],
            )
          : AudioRecorderStateActive(
              recorderStatus: AudioRecorderStatus(
                isRecording: true,
                recordDuration: pcm.timestamp,
              ),
              // pcm: [pcm],
            );
      // print("new State $newState");
      emit(newState);
      // Update the pcmList and add to the stream
      pcmList.add(pcm);
      pcmStreamController.add(pcmList);
    }
  }

  void _onGetAudioRecorderStatusStream(
    GetAudioRecorderStatusStream event,
    Emitter<AudioRecorderState> emit,
  ) async {
    // Await stream for safe emit call
    // because emitter becomes invalid when this function returns
    await for (final status in _recorderStatusStreamUsecase()) {
      final newState = state is AudioRecorderStateActive
          ? (state as AudioRecorderStateActive).copyWith(recorderStatus: status)
          : AudioRecorderStateActive(
              recorderStatus: status,
              // , pcm: []
            );
      emit(newState);
    }
  }

  Future<void> _onSaveAudioRecording(
    SaveAudioRecording event,
    Emitter<AudioRecorderState> emit,
  ) async {
    if (state is AudioRecorderStateActive) {
      final title = event.title ?? "Record ${DateTime.now().toIso8601String()}";
      final audioSave = AudioSave(data: pcmList, title: title);
      final result = await _saveRecordingUsecase(params: audioSave);
      if (result is DataFailure) {
        EchoLogger.e(result.error.toString());
      } else {
        _clearPcmList();
        EchoLogger.i("Recording Saved");
        Messenger.showSnackBar("Recording Saved!");
      }
    }
  }

  Future<void> _onDiscardAudioRecording(
    DiscardAudioRecording event,
    Emitter<AudioRecorderState> emit,
  ) async {
    if (state is AudioRecorderStateActive) {
      _clearPcmList();
      emit(AudioRecorderStateActive.initial());
    }
  }

  Future<void> _onRestartAudioRecording(
    RestartAudioRecording event,
    Emitter<AudioRecorderState> emit,
  ) async {
    final stopResult = await _stopRecorderUsecase();
    if (stopResult is DataFailure) {
      EchoLogger.e(stopResult.error.toString());
      return;
    } else {
      EchoLogger.i("Recording Saved");
    }
    final startResult = await _startRecordingUsecase();
    if (startResult is DataFailure) {
      EchoLogger.e(startResult.error.toString());
    } else {
      EchoLogger.i("Recording Saved");
    }
  }

  void _clearPcmList() {
    pcmList.clear();
    pcmStreamController.add([]);
  }
}
