import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an AudioSave entity', () {
    final entity = AudioSave(data: [], title: 'Record 01');

    expect(entity, isA<AudioSave>());
  });
}
