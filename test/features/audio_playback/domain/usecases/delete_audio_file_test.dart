import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioLibraryRepository extends Mock
    implements AudioLibraryRepository {}

void main() {
  final mockAudioLibraryRepository = MockAudioLibraryRepository();

  final deleteAudioFileUsecase = DeleteAudioFileUsecase(
    mockAudioLibraryRepository,
  );

  test('should call getAllRecords and return DataState', () async {
    final entity = AudioFile(
      title: "title",
      path: "path",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );
    when(
      () => mockAudioLibraryRepository.deleteAudioFile(entity),
    ).thenAnswer((_) async => DataSuccess(unit));

    final result = await deleteAudioFileUsecase(params: entity);

    expect(result, isA<DataState>());
  });
}
