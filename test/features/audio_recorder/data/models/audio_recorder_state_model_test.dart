import 'package:audiorecorder/features/audio_recorder/data/models/audio_recorder_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecorderStateModel from constructor', () {
    final model = AudioRecorderStateModel(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    expect(model, isA<AudioRecorderStateModel>());
  });

  test('should create an AudioRecorderStateModel from Map', () {
    final map = {"isRecording": true, "recordDuration": 873.5};
    final model = AudioRecorderStateModel.fromMap(map);

    expect(model, isA<AudioRecorderStateModel>());
  });
}
