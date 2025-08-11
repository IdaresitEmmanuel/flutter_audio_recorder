import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderState entity', () {
    final entity = AudioRecorderState(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    expect(entity, isA<AudioRecorderState>());
  });
}
