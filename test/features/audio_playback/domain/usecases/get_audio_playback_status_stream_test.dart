import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_playback_status_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlaybackRepository extends Mock
    implements AudioPlaybackRepository {}

void main() {
  final mockAudioPlaybackRepository = MockAudioPlaybackRepository();
  final getAudioPlaybackStatusStreamUsecase =
      GetAudioPlaybackStatusStreamUsecase(mockAudioPlaybackRepository);

  test('should call stop() and return dataState', () async {
    when(() => mockAudioPlaybackRepository.playbackStatus()).thenAnswer(
      (_) => Stream.value(
        AudioPlaybackStatus(
          fileName: "fileName",
          playerState: AudioPlayerState.paused,
          progressDuration: Duration.zero,
        ),
      ),
    );

    final result = getAudioPlaybackStatusStreamUsecase();

    expectLater(result, emitsInOrder([isA<AudioPlaybackStatus>()]));
  });
}
