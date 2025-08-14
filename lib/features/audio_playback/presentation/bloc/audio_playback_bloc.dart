import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_event.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlaybackBloc extends Bloc<AudioPlaybackEvent, AudioPlaybackState> {
  final RequestStoragePermissionUsecase _requestStoragePermissionUsecase;
  final GetAudioFilesUsecase _getAudioFilesUsecase;
  final DeleteAudioFileUsecase _deleteAudioFileUsecase;

  AudioPlaybackBloc(
    this._requestStoragePermissionUsecase,
    this._getAudioFilesUsecase,
    this._deleteAudioFileUsecase,
  ) : super(AudioPlaybackSLoading()) {
    on<RequestStoragePermission>(_onRequestStoragePermission);
    on<GetAudioFiles>(_onGetAudioFiles);
    on<DeleteAudioFile>(_onDeleteAudioFile);
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

  Future<void> _onGetAudioFiles(
    GetAudioFiles event,
    Emitter<AudioPlaybackState> emit,
  ) async {
    final result = await _getAudioFilesUsecase();
    if (result is DataSuccess) {
      final s = (result as DataSuccess<List<AudioFile>>);
      emit(AudioPlaybackDone(fileList: s.data ?? []));
    } else {
      EchoLogger.e(result);
      emit(AudioPlaybackDone(fileList: []));
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
      }
      EchoLogger.d("AudioFile ${event.audioFile.title} deleted!");
    } else {
      EchoLogger.e(result);
    }
  }
}
