import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_storage_repository.dart';
import 'package:dartz/dartz.dart';

class SaveRecordingUsecase extends Usecase<DataState<Unit>, AudioSave> {
  final AudioStorageRepository _audioStorageRepository;
  SaveRecordingUsecase(this._audioStorageRepository);

  @override
  Future<DataState<Unit>> call({required AudioSave params}) {
    return _audioStorageRepository.saveAudio(params);
  }
}
