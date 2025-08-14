import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioLibraryRepository extends Mock
    implements AudioLibraryRepository {}

void main() {
  final mockAudioLibraryRepository = MockAudioLibraryRepository();

  final getAudioFilesUsecase = GetAudioFilesUsecase(mockAudioLibraryRepository);

  test('should call getAllRecords and return DataState', () async {
    when(
      () => mockAudioLibraryRepository.getAllRecords(),
    ).thenAnswer((_) async => DataSuccess([]));

    final result = await getAudioFilesUsecase();

    expect(result, isA<DataState>());
  });
}
