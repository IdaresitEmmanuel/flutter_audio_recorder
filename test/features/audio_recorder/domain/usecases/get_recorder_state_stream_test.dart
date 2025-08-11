import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() async {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final getRecorderStatusStreamUsecase = GetRecorderStatusStreamUsecase(
    mockAudioRecorderRepository,
  );
  test('should call stateStream and return AudioRecorderStatus', () async {
    const entity = AudioRecorderStatus(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    when(
      () => mockAudioRecorderRepository.statusStream(),
    ).thenAnswer((_) => Stream.value(entity));

    final result = getRecorderStatusStreamUsecase();

    expectLater(result, emitsInOrder([entity, emitsDone]));
    verify(() => mockAudioRecorderRepository.statusStream());
  });
}
