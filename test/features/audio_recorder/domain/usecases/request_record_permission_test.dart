import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioRecorderRepository extends Mock
    implements AudioRecorderRepository {}

void main() async {
  final mockAudioRecorderRepository = MockAudioRecorderRepository();
  final requestRecordPermissionUsecase = RequestRecordPermissionUsecase(
    mockAudioRecorderRepository,
  );
  test('should call stateStream and return AudioRecorderStatus', () async {
    when(
      () => mockAudioRecorderRepository.requestPermission(),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await requestRecordPermissionUsecase();

    expect(result, isA<DataState>());
    verify(() => mockAudioRecorderRepository.requestPermission());
  });
}
