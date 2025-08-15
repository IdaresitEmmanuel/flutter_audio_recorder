import 'package:audiorecorder/core/presentation/widgets/messenger.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_playback_status_stream.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/pause_audio_player.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/play_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/seek_to_position.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/stop_audio_player.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_event.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlaybackBloc extends Bloc<AudioPlaybackEvent, AudioPlaybackState> {
  final RequestStoragePermissionUsecase _requestStoragePermissionUsecase;
  final GetAudioFilesUsecase _getAudioFilesUsecase;
  final DeleteAudioFileUsecase _deleteAudioFileUsecase;
  final PlayAudioFileUsecase _playAudioFileUsecase;
  final PauseAudioPlayerUsecase _pauseAudioPlayerUsecase;
  final SeekToPositionUsecase _seekToPositionUsecase;
  final StopAudioPlayerUsecase _stopAudioPlayerUsecase;
  final GetAudioPlaybackStatusStreamUsecase
  _getAudioPlaybackStatusStreamUsecase;
  AudioPlaybackBloc(
    this._requestStoragePermissionUsecase,
    this._getAudioFilesUsecase,
    this._deleteAudioFileUsecase,
    this._playAudioFileUsecase,
    this._pauseAudioPlayerUsecase,
    this._seekToPositionUsecase,
    this._stopAudioPlayerUsecase,
    this._getAudioPlaybackStatusStreamUsecase,
  ) : super(AudioPlaybackLoading()) {
    on<RequestStoragePermission>(_onRequestStoragePermission);
    on<GetAudioFiles>(_onGetAudioFiles);
    on<DeleteAudioFile>(_onDeleteAudioFile);
    //player
    on<PlayAudioFile>(_onPlayAudioFile);
    on<PauseAudioPlayer>(_onPauseAudioPlayer);
    on<SeekToPosition>(_onSeekToPosition);
    on<StopAudioPlayer>(_onStopAudioPlayer);
    on<GetAudioPlaybackStatus>(_onGetAudioPlaybackStatus);
  }

  Future<void> _onRequestStoragePermission(
    RequestStoragePermission event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _requestStoragePermissionUsecase();
    if (result is DataSuccess) {
      EchoLogger.i("Storage permission granted");
    } else {
      EchoLogger.e(result);
    }
  }

  // Future<void>
  _onGetAudioFiles(
    GetAudioFiles event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final hasPermission = await _requestStoragePermissionUsecase();
    if (hasPermission is! DataSuccess) return;
    final result = await _getAudioFilesUsecase();
    if (result is DataSuccess) {
      final s = (result as DataSuccess<List<AudioFile>>);
      final newState = state is AudioPlaybackDone
          ? (state as AudioPlaybackDone).copyWith(fileList: s.data)
          : AudioPlaybackDone.initial().copyWith(fileList: s.data ?? []);
      emit(newState);
    } else {
      EchoLogger.e(result);
      final newState = state is AudioPlaybackDone
          ? (state as AudioPlaybackDone).copyWith(fileList: [])
          : AudioPlaybackDone.initial().copyWith(fileList: []);
      emit(newState);
    }
  }

  Future<void> _onDeleteAudioFile(
    DeleteAudioFile event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _deleteAudioFileUsecase(params: event.audioFile);
    if (result is DataSuccess) {
      if (state is AudioPlaybackDone) {
        final newState = (state as AudioPlaybackDone).copyWith(
          fileList: (state as AudioPlaybackDone).fileList
              .where((af) => af.path != event.audioFile.path)
              .toList(),
        );

        emit(newState);
        Messenger.showSnackBar("Audio File deleted!");
      }
      EchoLogger.d("AudioFile ${event.audioFile.title} deleted!");
    } else {
      EchoLogger.e(result);
    }
  }

  // Player events
  Future<void> _onPlayAudioFile(
    PlayAudioFile event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _playAudioFileUsecase(params: event.audioFile);
    if (result is DataSuccess) {
      EchoLogger.d("AudioFile ${event.audioFile.title} playing!");
    } else {
      EchoLogger.e(result);
    }
  }

  Future<void> _onPauseAudioPlayer(
    PauseAudioPlayer event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _pauseAudioPlayerUsecase();
    if (result is DataSuccess) {
      EchoLogger.d("AudioFile paused!");
    } else {
      EchoLogger.e(result);
    }
  }

  Future<void> _onSeekToPosition(
    SeekToPosition event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _seekToPositionUsecase(params: event.position);
    if (result is DataSuccess) {
      EchoLogger.d("seek:position:${event.position}");
    } else {
      EchoLogger.e(result);
    }
  }

  Future<void> _onStopAudioPlayer(
    StopAudioPlayer event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _stopAudioPlayerUsecase();
    if (result is DataSuccess) {
      EchoLogger.d("Audio player stopped!");
    } else {
      EchoLogger.e(result);
    }
  }

  Future<void> _onGetAudioPlaybackStatus(
    GetAudioPlaybackStatus event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    await for (var status in _getAudioPlaybackStatusStreamUsecase()) {
      final newState = state is AudioPlaybackDone
          ? (state as AudioPlaybackDone).copyWith(status: status)
          : AudioPlaybackDone.initial().copyWith(status: status);
      emit(newState);
    }
  }
}
