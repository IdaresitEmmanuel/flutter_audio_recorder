import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_playback_status.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_playback_status_stream.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/pause_audio_player.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/play_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/seek_to_position.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/stop_audio_player.dart';
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

class MockPlayAudioFileUsecase extends Mock implements PlayAudioFileUsecase {}

class MockPauseAudioPlayerUsecase extends Mock
    implements PauseAudioPlayerUsecase {}

class MockSeekToPositionUsecase extends Mock implements SeekToPositionUsecase {}

class MockStopAudioPlayerUsecase extends Mock
    implements StopAudioPlayerUsecase {}

class MockGetAudioPlaybackStatusStreamUsecase extends Mock
    implements GetAudioPlaybackStatusStreamUsecase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockRequestStoragePermissionUsecase =
      MockRequestStoragePermissionUsecase();
  final mockGetAudioFilesUsecase = MockGetAudioFilesUsecase();
  final mockDeleteAudioFileUsecase = MockDeleteAudioFileUsecase();
  final mockPlayAudioFileUsecase = MockPlayAudioFileUsecase();
  final mockPauseAudioPlayerUsecase = MockPauseAudioPlayerUsecase();
  final mockMockSeekToPositionUsecase = MockSeekToPositionUsecase();
  final mockStopAudioPlayerUsecase = MockStopAudioPlayerUsecase();
  final mockGetAudioPlaybackStatusStreamUsecase =
      MockGetAudioPlaybackStatusStreamUsecase();

  buildBloc() => AudioPlaybackBloc(
    mockRequestStoragePermissionUsecase,
    mockGetAudioFilesUsecase,
    mockDeleteAudioFileUsecase,
    mockPlayAudioFileUsecase,
    mockPauseAudioPlayerUsecase,
    mockMockSeekToPositionUsecase,
    mockStopAudioPlayerUsecase,
    mockGetAudioPlaybackStatusStreamUsecase,
  );

  blocTest(
    'should call request storage permission',
    build: buildBloc,
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
    build: buildBloc,
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
      build: buildBloc,
      setUp: () {
        when(
          () => mockDeleteAudioFileUsecase(params: entity),
        ).thenAnswer((_) async => DataSuccess(unit));
      },
      seed: () => AudioPlaybackDone.initial().copyWith(fileList: [entity]),
      act: (bloc) => bloc.add(DeleteAudioFile(audioFile: entity)),
      expect: () => [AudioPlaybackDone.initial().copyWith(fileList: [])],
      verify: (bloc) =>
          verify(() => mockDeleteAudioFileUsecase(params: entity)),
    );
  });

  group('_onPlayAudioFile', () {
    final entity = AudioFile(
      title: "title",
      path: "path",
      createdAt: DateTime.now(),
      duration: Duration.zero,
    );
    blocTest(
      'should call playAudioFile',
      build: buildBloc,
      setUp: () {
        when(
          () => mockPlayAudioFileUsecase(params: entity),
        ).thenAnswer((_) async => DataSuccess(unit));
      },
      act: (bloc) => bloc.add(PlayAudioFile(audioFile: entity)),
      verify: (bloc) => verify(() => mockPlayAudioFileUsecase(params: entity)),
    );
  });

  blocTest(
    'should call pause',
    build: buildBloc,
    setUp: () {
      when(
        () => mockPauseAudioPlayerUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(PauseAudioPlayer()),
    verify: (bloc) => verify(() => mockPauseAudioPlayerUsecase()),
  );

  blocTest(
    'should call seek',
    build: buildBloc,
    setUp: () {
      when(
        () => mockMockSeekToPositionUsecase(params: Duration.zero),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(SeekToPosition(position: Duration.zero)),
    verify: (bloc) =>
        verify(() => mockMockSeekToPositionUsecase(params: Duration.zero)),
  );

  blocTest(
    'should call stop',
    build: buildBloc,
    setUp: () {
      when(
        () => mockStopAudioPlayerUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(StopAudioPlayer()),
    verify: (bloc) => verify(() => mockStopAudioPlayerUsecase()),
  );

  blocTest(
    'should call getAudioPlaybackStatus and emit done state',
    build: buildBloc,
    setUp: () {
      when(() => mockGetAudioPlaybackStatusStreamUsecase()).thenAnswer(
        (_) => Stream.value(
          AudioPlaybackStatus(
            fileName: "fileName",
            playerState: AudioPlayerState.paused,
            progressDuration: Duration.zero,
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(GetAudioPlaybackStatus()),
    verify: (bloc) => verify(() => mockGetAudioPlaybackStatusStreamUsecase()),
    expect: () => [isA<AudioPlaybackDone>()],
  );
}
