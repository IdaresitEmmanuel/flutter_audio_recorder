import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_state_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() async {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final getRecorderStateStreamUsecase = GetRecorderStateStreamUsecase(
    mockAudioRecorderRepository,
  );
  test('should call startRecording and return DataState', () async {
    const entity = AudioRecorderState(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    when(
      () => mockAudioRecorderRepository.stateStream(),
    ).thenAnswer((_) => Stream.value(entity));

    final result = getRecorderStateStreamUsecase();

    expectLater(result, emitsInOrder([entity, emitsDone]));
    verify(() => mockAudioRecorderRepository.stateStream());
  });
}
