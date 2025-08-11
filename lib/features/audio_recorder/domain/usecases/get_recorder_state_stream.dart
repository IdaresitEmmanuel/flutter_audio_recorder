import 'package:audiorecorder/core/usecase/usecase_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';

class GetRecorderStateStreamUsecase
    extends UsecaseStream<AudioRecorderState, void> {
  final AudioRecorderRepository _audioRecorderRepository;
  GetRecorderStateStreamUsecase(this._audioRecorderRepository);
  @override
  Stream<AudioRecorderState> call({void params}) {
    return _audioRecorderRepository.stateStream();
  }
}
