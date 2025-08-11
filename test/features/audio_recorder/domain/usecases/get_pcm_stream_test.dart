import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() async {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final getPcmStreamUsecase = GetPcmStreamUsecase(mockAudioRecorderRepository);
  test('should call startRecording and return DataState', () async {
    const entity = AudioRecorderPcm(timestamp: Duration.zero, data: []);
    when(
      () => mockAudioRecorderRepository.pcmStream(),
    ).thenAnswer((_) => Stream.value(entity));

    final result = getPcmStreamUsecase();

    expectLater(result, emitsInOrder([entity, emitsDone]));
    verify(() => mockAudioRecorderRepository.pcmStream());
  });
}
