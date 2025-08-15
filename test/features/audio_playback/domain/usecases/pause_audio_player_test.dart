import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/pause_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlaybackRepository extends Mock
    implements AudioPlaybackRepository {}

void main() {
  final mockAudioPlaybackRepository = MockAudioPlaybackRepository();
  final pauseAudioPlayerUsecase = PauseAudioPlayerUsecase(
    mockAudioPlaybackRepository,
  );

  test('should call pause and return dataState', () async {
    when(
      () => mockAudioPlaybackRepository.pause(),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await pauseAudioPlayerUsecase();

    expect(result, isA<DataSuccess>());
  });
}
