import 'package:audiorecorder/features/audio_playback/data/models/audio_record_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecordModel', () {
    final model = AudioFileModel(
      title: 'Record 01',
      path: '/storage/record.wav',
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );

    expect(model, isA<AudioFileModel>());
  });
}
