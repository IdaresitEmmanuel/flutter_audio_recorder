import 'package:audiorecorder/core/usecase/usecase_stream.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';

class GetAudioPlaybackStatusStreamUsecase
    extends UsecaseStream<AudioPlaybackStatus, void> {
  final AudioPlaybackRepository _audioPlaybackRepository;
  GetAudioPlaybackStatusStreamUsecase(this._audioPlaybackRepository);
  @override
  Stream<AudioPlaybackStatus> call({void params}) {
    return _audioPlaybackRepository.playbackStatus();
  }
}
