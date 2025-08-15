import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:dartz/dartz.dart';

class SeekToPositionUsecase extends Usecase<DataState<Unit>, Duration> {
  final AudioPlaybackRepository _audioPlaybackRepository;
  SeekToPositionUsecase(this._audioPlaybackRepository);
  @override
  Future<DataState<Unit>> call({required Duration params}) {
    return _audioPlaybackRepository.seek(params);
  }
}
