import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:dartz/dartz.dart';

class PauseAudioPlayerUsecase extends Usecase<DataState<Unit>, void> {
  final AudioPlaybackRepository _audioPlaybackRepository;
  PauseAudioPlayerUsecase(this._audioPlaybackRepository);
  @override
  Future<DataState<Unit>> call({void params}) {
    return _audioPlaybackRepository.pause();
  }
}
