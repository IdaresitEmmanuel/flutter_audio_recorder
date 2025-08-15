import 'package:audioplayers/audioplayers.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_player_service.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeDeviceFileSource extends Fake implements DeviceFileSource {}

void main() {
  final mockAudioPlayer = MockAudioPlayer();
  final audioPlayerService = AudioPlayerService(mockAudioPlayer);

  setUpAll(() {
    registerFallbackValue(FakeDeviceFileSource());
  });

  final audioFile = AudioFile(
    title: "title",
    path: "path",
    createdAt: DateTime.now(),
    duration: Duration.zero,
  );
  final audioSource = DeviceFileSource(audioFile.path);

  group('play', () {
    test('should resume when audioFile already exist', () async {
      when(() => mockAudioPlayer.state).thenReturn(PlayerState.playing);
      when(() => mockAudioPlayer.source).thenReturn(audioSource);

      when(() => mockAudioPlayer.resume()).thenAnswer((_) async => {});

      final result = await audioPlayerService.play(audioFile);

      expect(result, true);
      verify(() => mockAudioPlayer.state);
      verify(() => mockAudioPlayer.source);
      verify(() => mockAudioPlayer.resume());
    });

    test('should set source and play when audioFile doesn\'t exist', () async {
      when(() => mockAudioPlayer.state).thenReturn(PlayerState.disposed);
      when(() => mockAudioPlayer.source).thenReturn(null);

      when(() => mockAudioPlayer.play(any())).thenAnswer((_) async => {});

      final result = await audioPlayerService.play(audioFile);

      expect(result, true);
      verify(() => mockAudioPlayer.state);
      verify(() => mockAudioPlayer.source);
      verify(() => mockAudioPlayer.play(any()));
    });
  });

  group('pause', () {
    test('should call pause when audio file exist', () async {
      when(() => mockAudioPlayer.state).thenReturn(PlayerState.playing);
      when(() => mockAudioPlayer.source).thenReturn(audioSource);

      when(() => mockAudioPlayer.pause()).thenAnswer((_) async => {});

      final result = await audioPlayerService.pause();

      expect(result, true);
      verify(() => mockAudioPlayer.state);
      verify(() => mockAudioPlayer.source);
      verify(() => mockAudioPlayer.pause());
    });
  });

  // Seek
  test('should seek when audio is paused or playing', () async {
    final position = Duration.zero;
    when(() => mockAudioPlayer.state).thenReturn(PlayerState.playing);

    when(() => mockAudioPlayer.seek(position)).thenAnswer((_) async => {});

    final result = await audioPlayerService.seek(position);

    expect(result, true);
    verify(() => mockAudioPlayer.state);
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
        when(() => mockAudioPlayer.source).thenReturn(audioSource);
        when(
          () => mockAudioPlayer.onPlayerStateChanged,
        ).thenAnswer((_) => Stream.value(PlayerState.playing));
        when(
          () => mockAudioPlayer.onPositionChanged,
        ).thenAnswer((_) => Stream.value(Duration(seconds: 5)));

        final result = audioPlayerService.playbackStatus();

        expectLater(result, emitsInOrder([isA<Map>(), isA<Map>()]));
      },
    );
  });
}
