import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderStatus entity', () {
    final entity = AudioRecorderStatus(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    expect(entity, isA<AudioRecorderStatus>());
  });
}
