import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_storage_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/save_recording.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioStorageRepository extends Mock
    implements AudioStorageRepository {}

void main() {
  final mockAudioStorageRepository = MockAudioStorageRepository();
  final saveRecordingUsecase = SaveRecordingUsecase(mockAudioStorageRepository);

  test('should call saveAudio and return DataState', () async {
    final audioSave = AudioSave(
      data: [
        AudioRecorderPcm(
          timestamp: Duration.zero,
          data: [0.00037262, -0.003837],
        ),
      ],
      title: 'Record 01',
    );
    when(
      () => mockAudioStorageRepository.saveAudio(audioSave),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await saveRecordingUsecase(params: audioSave);

    expect(result, isA<DataState>());
  });
}
