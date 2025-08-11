import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() async {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final startRecordingUsecase = StartRecordingUsecase(
    mockAudioRecorderRepository,
  );
  test('should call startRecording and return DataState', () async {
    when(
      () => mockAudioRecorderRepository.startRecording(),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await startRecordingUsecase();

    expect(result, isA<DataState>());
    verify(() => mockAudioRecorderRepository.startRecording());
  });
}
