import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioPlaybackStatus entity', () {
    final entity = AudioPlaybackStatus(
      fileName: "fileName",
      playerState: AudioPlayerState.playing,
      progressDuration: Duration.zero,
    );

    expect(entity, isA<AudioPlaybackStatus>());
  });
}
