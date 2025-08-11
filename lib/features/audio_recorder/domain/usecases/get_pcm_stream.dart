import 'package:audiorecorder/core/usecase/usecase_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';

class GetPcmStreamUsecase extends UsecaseStream<AudioRecorderPcm, void> {
  final AudioRecorderRepository _audioRecorderRepository;
  GetPcmStreamUsecase(this._audioRecorderRepository);
  @override
  Stream<AudioRecorderPcm> call({void params}) {
    return _audioRecorderRepository.pcmStream();
  }
}
