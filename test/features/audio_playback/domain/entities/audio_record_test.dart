import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioRecord Entity', () {
    final entity = AudioFile(
      title: "Record 01",
      path: "/record",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );

    expect(entity, isA<AudioFile>());
  });
}
