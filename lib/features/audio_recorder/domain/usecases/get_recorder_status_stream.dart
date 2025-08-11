import 'package:audiorecorder/core/usecase/usecase_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';

class GetRecorderStatusStreamUsecase
    extends UsecaseStream<AudioRecorderStatus, void> {
  final AudioRecorderRepository _audioRecorderRepository;
  GetRecorderStatusStreamUsecase(this._audioRecorderRepository);
  @override
  Stream<AudioRecorderStatus> call({void params}) {
    return _audioRecorderRepository.statusStream();
  }
}
