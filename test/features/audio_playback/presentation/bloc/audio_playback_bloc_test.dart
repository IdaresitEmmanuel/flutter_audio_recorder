import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_bloc.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_event.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestStoragePermissionUsecase extends Mock
    implements RequestStoragePermissionUsecase {}

class MockGetAudioFilesUsecase extends Mock implements GetAudioFilesUsecase {}

class MockDeleteAudioFileUsecase extends Mock
    implements DeleteAudioFileUsecase {}

void main() {
  final mockRequestStoragePermissionUsecase =
      MockRequestStoragePermissionUsecase();
  final mockGetAudioFilesUsecase = MockGetAudioFilesUsecase();
  final mockDeleteAudioFileUsecase = MockDeleteAudioFileUsecase();

  blocTest(
    'should call request storage permission',
    build: () => AudioPlaybackBloc(
      mockRequestStoragePermissionUsecase,
      mockGetAudioFilesUsecase,
      mockDeleteAudioFileUsecase,
    ),
    setUp: () {
      when(
        () => mockRequestStoragePermissionUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(RequestStoragePermission()),
    verify: (bloc) => verify(() => mockRequestStoragePermissionUsecase()),
  );

  blocTest(
    'should call getAudioFile and emit AudioPlaybackDone',
    build: () => AudioPlaybackBloc(
      mockRequestStoragePermissionUsecase,
      mockGetAudioFilesUsecase,
      mockDeleteAudioFileUsecase,
    ),
    setUp: () {
      when(
        () => mockGetAudioFilesUsecase(),
      ).thenAnswer((_) async => DataSuccess([]));
    },
    act: (bloc) => bloc.add(GetAudioFiles()),
    expect: () => [isA<AudioPlaybackDone>()],
    verify: (bloc) => verify(() => mockGetAudioFilesUsecase()),
  );

  group('_onDeleteAudioFile', () {
    final entity = AudioFile(
      title: "title",
      path: "path",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );
    blocTest(
      'should call DeleteAudioFile and emit AudioPlaybackDone without that file',
      build: () => AudioPlaybackBloc(
        mockRequestStoragePermissionUsecase,
        mockGetAudioFilesUsecase,
        mockDeleteAudioFileUsecase,
      ),
      setUp: () {
        when(
          () => mockDeleteAudioFileUsecase(params: entity),
        ).thenAnswer((_) async => DataSuccess(unit));
      },
      seed: () => AudioPlaybackDone(fileList: [entity]),
      act: (bloc) => bloc.add(DeleteAudioFile(audioFile: entity)),
      expect: () => [AudioPlaybackDone(fileList: [])],
      verify: (bloc) =>
          verify(() => mockDeleteAudioFileUsecase(params: entity)),
    );
  });
}
