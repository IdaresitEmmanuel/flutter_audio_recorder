import 'package:audiorecorder/features/audio_playback/data/datasources/audio_player_service.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeAudioSource extends Fake implements ProgressiveAudioSource {}

void main() {
  final mockAudioPlayer = MockAudioPlayer();
  final audioPlayerService = AudioPlayerService(mockAudioPlayer);

  setUp(() {
    registerFallbackValue(FakeAudioSource());
  });

  final audioFile = AudioFile(
    title: "title",
    path: "path",
    createdAt: DateTime.now(),
    duration: Duration.zero,
  );
  final audioSource = AudioSource.uri(Uri.file(audioFile.path));

  group('play', () {
    test('should resume when audioFile already exist', () async {
      when(() => mockAudioPlayer.audioSource).thenReturn(audioSource);

      when(() => mockAudioPlayer.play()).thenAnswer((_) async => {});

      final result = await audioPlayerService.play(audioFile);

      expect(result, true);
      verify(() => mockAudioPlayer.audioSource);
      verify(() => mockAudioPlayer.play());
    });

    test('should set source and play when audioFile doesn\'t exist', () async {
      when(() => mockAudioPlayer.audioSource).thenReturn(null);

      when(
        () => mockAudioPlayer.setAudioSource(any(), preload: true),
      ).thenAnswer((_) async => Duration.zero);

      when(() => mockAudioPlayer.play()).thenAnswer((_) async => {});

      final result = await audioPlayerService.play(audioFile);

      expect(result, true);
      verify(() => mockAudioPlayer.audioSource);
      verify(() => mockAudioPlayer.setAudioSource(any(), preload: true));
      verify(() => mockAudioPlayer.play());
    });
  });

  group('pause', () {
    test('should call pause when audio file exist', () async {
      when(() => mockAudioPlayer.audioSource).thenReturn(audioSource);

      when(() => mockAudioPlayer.pause()).thenAnswer((_) async => {});

      final result = await audioPlayerService.pause();

      expect(result, true);
      verify(() => mockAudioPlayer.audioSource);
      verify(() => mockAudioPlayer.pause());
    });
  });

  // Seek
  test('should seek when audio is paused or playing', () async {
    final position = Duration.zero;

    when(() => mockAudioPlayer.seek(position)).thenAnswer((_) async => {});

    final result = await audioPlayerService.seek(position);

    expect(result, true);
    verify(() => mockAudioPlayer.seek(position));
  });

  // Stop
  test('should call stop', () async {
    when(() => mockAudioPlayer.stop()).thenAnswer((_) async => {});

    final result = await audioPlayerService.stop();

    expect(result, true);
    verify(() => mockAudioPlayer.stop());
  });

  group('playbackStatus', () {
    test(
      'should return a map from the combined state and position stream',
      () async {
        when(() => mockAudioPlayer.audioSource).thenReturn(audioSource);
        when(
          () => mockAudioPlayer.playerState,
        ).thenReturn(PlayerState(true, ProcessingState.ready));
        when(() => mockAudioPlayer.playerStateStream).thenAnswer(
          (_) => Stream.value(PlayerState(true, ProcessingState.ready)),
        );
        when(
          () => mockAudioPlayer.positionStream,
        ).thenAnswer((_) => Stream.value(Duration(seconds: 5)));

        final result = audioPlayerService.playbackStatus();

        expectLater(result, emitsInOrder([isA<Map>(), isA<Map>()]));
      },
    );
  });
}
