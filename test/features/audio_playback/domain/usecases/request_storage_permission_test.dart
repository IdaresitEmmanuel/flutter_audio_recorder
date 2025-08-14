import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioLibraryRepository extends Mock
    implements AudioLibraryRepository {}

void main() {
  final mockAudioLibraryRepository = MockAudioLibraryRepository();

  final requestStoryPermissionUsecase = RequestStoragePermissionUsecase(
    mockAudioLibraryRepository,
  );

  test(
    'should call requestReadAndWritePermission and return DataState',
    () async {
      when(
        () => mockAudioLibraryRepository.requestReadAndWritePermission(),
      ).thenAnswer((_) async => DataSuccess(unit));

      final result = await requestStoryPermissionUsecase();

      expect(result, isA<DataState>());
    },
  );
}
