import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderStatusModel from constructor', () {
    final model = AudioRecorderStatusModel(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    expect(model, isA<AudioRecorderStatusModel>());
  });

  test('should create an AudioRecorderStatusModel from Map', () {
    final map = {"isRecording": true, "recordDuration": 873.5};
    final model = AudioRecorderStatusModel.fromMap(map);

    expect(model, isA<AudioRecorderStatusModel>());
  });
}
