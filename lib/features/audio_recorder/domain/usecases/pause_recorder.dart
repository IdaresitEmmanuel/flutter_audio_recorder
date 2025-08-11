import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:dartz/dartz.dart';

class PauseRecorderUsecase extends Usecase<DataState<Unit>, void> {
  final AudioRecorderRepository _audioRecorderRepository;
  PauseRecorderUsecase(this._audioRecorderRepository);
  @override
  Future<DataState<Unit>> call({void params}) {
    return _audioRecorderRepository.pause();
  }
}
