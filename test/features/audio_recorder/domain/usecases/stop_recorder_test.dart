import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final stopRecorderUsecase = StopRecorderUsecase(mockAudioRecorderRepository);

  test('should call stop() and return DataState', () async {
    when(
      () => mockAudioRecorderRepository.stop(),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await stopRecorderUsecase.call();

    expect(result, isA<DataState>());
    verify(() => mockAudioRecorderRepository.stop());
  });
}
