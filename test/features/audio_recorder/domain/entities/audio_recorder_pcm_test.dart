import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderPcm Entity', () {
    final entity = AudioRecorderPcm(timestamp: Duration.zero, data: []);

    expect(entity, isA<AudioRecorderPcm>());
  });
}
