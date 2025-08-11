import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_pcm_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderPcmModel from constructor', () {
    final model = AudioRecorderPcmModel(timestamp: Duration.zero, data: []);
    expect(model, isA<AudioRecorderPcmModel>());
  });
  test('should create an AudioRecorderPcmModel from Map', () {
    final map = {
      'timestamp': 248.5,
      'data': [0.45803, 0.000021, -0.00345],
    };
    final model = AudioRecorderPcmModel.fromMap(map);

    expect(model, isA<AudioRecorderPcmModel>());
  });
}
