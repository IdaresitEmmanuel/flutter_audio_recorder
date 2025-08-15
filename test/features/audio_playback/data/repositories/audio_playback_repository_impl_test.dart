import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_player_service.dart';
import 'package:audiorecorder/features/audio_playback/data/models/audio_playback_status_model.dart';
import 'package:audiorecorder/features/audio_playback/data/repositories/audio_playback_repository_impl.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlayerService extends Mock implements AudioPlayerService {}

void main() {
  final mockAudioPlayerService = MockAudioPlayerService();
  final audioPlaybackRepositoryImpl = AudioPlaybackRepositoryImpl(
    mockAudioPlayerService,
  );

  // Play
  test('should call play and return DataState', () async {
    final audioFile = AudioFile(
      title: "title",
      path: "path",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );
    when(
      () => mockAudioPlayerService.play(audioFile),
    ).thenAnswer((_) async => true);

    final result = await audioPlaybackRepositoryImpl.play(audioFile);

    expect(result, isA<DataSuccess>());
    verify(() => mockAudioPlayerService.play(audioFile));
  });

  // Pause
  test('should call pause and return DataState', () async {
    when(() => mockAudioPlayerService.pause()).thenAnswer((_) async => true);

    final result = await audioPlaybackRepositoryImpl.pause();
    expect(result, isA<DataSuccess>());
    verify(() => mockAudioPlayerService.pause());
  });

  // Seek
  test('should call seek(position) and return DataState', () async {
    final seekDuration = Duration.zero;
    when(
      () => mockAudioPlayerService.seek(seekDuration),
    ).thenAnswer((_) async => true);

    final result = await audioPlaybackRepositoryImpl.seek(seekDuration);
    expect(result, isA<DataSuccess>());
    verify(() => mockAudioPlayerService.seek(seekDuration));
  });

  // Stop
  test('should call stop() and return DataState', () async {
    when(() => mockAudioPlayerService.stop()).thenAnswer((_) async => true);

    final result = await audioPlaybackRepositoryImpl.stop();
    expect(result, isA<DataSuccess>());
    verify(() => mockAudioPlayerService.stop());
  });

  test('should return an AudioPlaybackStatusModel from a statusMap', () async {
    final map = {
      'fileName': 'Highbreed',
      'state': 'stopped',
      'position': Duration.zero.inSeconds,
    };

    when(
      () => mockAudioPlayerService.playbackStatus(),
    ).thenAnswer((_) => Stream.value(map));

    final result = audioPlaybackRepositoryImpl.playbackStatus();

    expectLater(result, emitsInOrder([isA<AudioPlaybackStatusModel>()]));
  });
}
