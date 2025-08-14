import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';

class GetAudioFilesUsecase extends Usecase<DataState<List<AudioFile>>, void> {
  final AudioLibraryRepository _audioLibraryRepository;
  GetAudioFilesUsecase(this._audioLibraryRepository);
  @override
  Future<DataState<List<AudioFile>>> call({void params}) {
    return _audioLibraryRepository.getAllRecords();
  }
}
