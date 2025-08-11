import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final pauseRecorderUsecase = PauseRecorderUsecase(
    mockAudioRecorderRepository,
  );

  test('should call pause() and return DataState', () async {
    when(
      () => mockAudioRecorderRepository.pause(),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await pauseRecorderUsecase.call();

    expect(result, isA<DataState>());
    verify(() => mockAudioRecorderRepository.pause());
  });
}
