import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/play_audio_file.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlaybackRepository extends Mock
    implements AudioPlaybackRepository {}

void main() {
  final mockAudioPlaybackRepository = MockAudioPlaybackRepository();

  final playAudioFileUsecase = PlayAudioFileUsecase(
    mockAudioPlaybackRepository,
  );

  test('should call play(audiofile) and return DataState', () async {
    final audioFile = AudioFile(
      title: "title",
      path: "path",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );

    when(
      () => mockAudioPlaybackRepository.play(audioFile),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await playAudioFileUsecase(params: audioFile);

    expect(result, isA<DataSuccess>());
  });
}
