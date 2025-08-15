import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:dartz/dartz.dart';

class PlayAudioFileUsecase extends Usecase<DataState<Unit>, AudioFile> {
  final AudioPlaybackRepository _audioPlaybackRepository;
  PlayAudioFileUsecase(this._audioPlaybackRepository);

  @override
  Future<DataState<Unit>> call({required AudioFile params}) {
    return _audioPlaybackRepository.play(params);
  }
}
