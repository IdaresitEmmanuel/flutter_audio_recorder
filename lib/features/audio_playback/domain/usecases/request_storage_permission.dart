import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:dartz/dartz.dart';

class RequestStoragePermissionUsecase extends Usecase<DataState<Unit>, void> {
  final AudioLibraryRepository _audioLibraryRepository;
  RequestStoragePermissionUsecase(this._audioLibraryRepository);
  @override
  Future<DataState<Unit>> call({params}) {
    return _audioLibraryRepository.requestReadAndWritePermission();
  }
}
