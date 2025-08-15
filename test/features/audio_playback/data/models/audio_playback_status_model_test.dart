import 'package:audiorecorder/features/audio_playback/data/models/audio_playback_status_model.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioPlaybackModel', () {
    final model = AudioPlaybackStatusModel(
      fileName: "fileName",
      playerState: AudioPlayerState.playing,
      progressDuration: Duration.zero,
    );

    expect(model, isA<AudioPlaybackStatusModel>());
  });

  test('should convert map to AudioPlayerbackModel', () {
    final map = {
      'fileName': 'Highbreed',
      'state': 'stopped',
      'position': Duration.zero.inSeconds,
    };

    final model = AudioPlaybackStatusModel.fromMap(map);

    expect(model, isA<AudioPlaybackStatusModel>());
  });
}
