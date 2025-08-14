import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAudioFileUsecase extends Usecase<DataState<Unit>, AudioFile> {
  final AudioLibraryRepository _audioLibraryRepository;
  DeleteAudioFileUsecase(this._audioLibraryRepository);

  @override
  Future<DataState<Unit>> call({required AudioFile params}) {
    return _audioLibraryRepository.deleteAudioFile(params);
  }
}
