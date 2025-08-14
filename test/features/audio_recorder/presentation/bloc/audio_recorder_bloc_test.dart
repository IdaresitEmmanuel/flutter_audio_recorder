import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_status.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_event.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockRequestRecordPermissionUsecase extends Mock
    implements RequestRecordPermissionUsecase {}

class MockStartRecordingUsecase extends Mock implements StartRecordingUsecase {}

class MockPauseRecorderUsecase extends Mock implements PauseRecorderUsecase {}

class MockResumeRecorderUsecase extends Mock implements ResumeRecorderUsecase {}

class MockStopRecorderUsecase extends Mock implements StopRecorderUsecase {}

class MockGetPcmStreamUsecase extends Mock implements GetPcmStreamUsecase {}

class MockGetRecorderStatusStreamUsecase extends Mock
    implements GetRecorderStatusStreamUsecase {}

void main() {
  final mockRequestRecordPermissionUsecase =
      MockRequestRecordPermissionUsecase();
  final mockStartRecordingUsecase = MockStartRecordingUsecase();
  final mockPauseRecorderUsecase = MockPauseRecorderUsecase();
  final mockResumeRecorderUsecase = MockResumeRecorderUsecase();
  final mockStopRecorderUsecase = MockStopRecorderUsecase();
  final mockGetPcmStreamUsecase = MockGetPcmStreamUsecase();
  final mockGetRecorderStatusStreamUsecase =
      MockGetRecorderStatusStreamUsecase();
   


  blocTest(
    '_onRequestRecordPermission: should call request permission',
    build: () => AudioRecorderBloc(
      mockRequestRecordPermissionUsecase,
      mockStartRecordingUsecase,
      mockPauseRecorderUsecase,
      mockResumeRecorderUsecase,
      mockStopRecorderUsecase,
      mockGetPcmStreamUsecase,
      mockGetRecorderStatusStreamUsecase,
    ),
    setUp: () {
      when(
        () => mockRequestRecordPermissionUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(RequestRecordPermission()),
    verify: (bloc) {
      verify(() => mockRequestRecordPermissionUsecase());
    },
  );

  blocTest(
    '_onStartAudioRecorder: should call start recorder and emit error state on error',
    build: () => AudioRecorderBloc(
      mockRequestRecordPermissionUsecase,
      mockStartRecordingUsecase,
      mockPauseRecorderUsecase,
      mockResumeRecorderUsecase,
      mockStopRecorderUsecase,
      mockGetPcmStreamUsecase,
      mockGetRecorderStatusStreamUsecase,
    ),
    setUp: () {
      when(
        () => mockRequestRecordPermissionUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
      when(
        () => mockStartRecordingUsecase(),
      ).thenAnswer((_) async => DataFailure(DataError(value: "error")));
    },
    act: (bloc) => bloc.add(StartAudioRecorder()),
    verify: (bloc) {
      verify(() => mockStartRecordingUsecase());
    },
    expect: () => [isA<AudioRecordStateError>()],
  );

  blocTest(
    '_onPauseAudioRecorder: should call pause',
    build: () => AudioRecorderBloc(
      mockRequestRecordPermissionUsecase,
      mockStartRecordingUsecase,
      mockPauseRecorderUsecase,
      mockResumeRecorderUsecase,
      mockStopRecorderUsecase,
      mockGetPcmStreamUsecase,
      mockGetRecorderStatusStreamUsecase,
    ),
    setUp: () {
      when(
        () => mockPauseRecorderUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(PauseAudioRecorder()),
    verify: (bloc) {
      verify(() => mockPauseRecorderUsecase());
    },
  );

  blocTest(
    '_onResumeAudioRecorder: should call resume',
    build: () => AudioRecorderBloc(
      mockRequestRecordPermissionUsecase,
      mockStartRecordingUsecase,
      mockPauseRecorderUsecase,
      mockResumeRecorderUsecase,
      mockStopRecorderUsecase,
      mockGetPcmStreamUsecase,
      mockGetRecorderStatusStreamUsecase,
    ),
    setUp: () {
      when(
        () => mockResumeRecorderUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(ResumeAudioRecorder()),
    verify: (bloc) {
      verify(() => mockResumeRecorderUsecase());
    },
  );

  blocTest(
    '_onStopAudioRecorder: should call stop',
    build: () => AudioRecorderBloc(
      mockRequestRecordPermissionUsecase,
      mockStartRecordingUsecase,
      mockPauseRecorderUsecase,
      mockResumeRecorderUsecase,
      mockStopRecorderUsecase,
      mockGetPcmStreamUsecase,
      mockGetRecorderStatusStreamUsecase,
    ),
    setUp: () {
      when(
        () => mockStopRecorderUsecase(),
      ).thenAnswer((_) async => DataSuccess(unit));
    },
    act: (bloc) => bloc.add(StopAudioRecorder()),
    verify: (bloc) {
      verify(() => mockStopRecorderUsecase());
    },
  );

  group('_onGetPcmStreamUsecase', () {
    final entity = AudioRecorderPcm(timestamp: Duration.zero, data: []);
    blocTest(
      'should call pcm stream and emit active state',
      build: () => AudioRecorderBloc(
        mockRequestRecordPermissionUsecase,
        mockStartRecordingUsecase,
        mockPauseRecorderUsecase,
        mockResumeRecorderUsecase,
        mockStopRecorderUsecase,
        mockGetPcmStreamUsecase,
        mockGetRecorderStatusStreamUsecase,
      ),
      setUp: () {
        when(
          () => mockGetPcmStreamUsecase(),
        ).thenAnswer((_) => Stream.value(entity));
      },
      act: (bloc) => bloc.add(GetAudioRecorderPcmStream()),
      verify: (bloc) {
        verify(() => mockGetPcmStreamUsecase());
      },
      expect: () => [isA<AudioRecorderStateActive>()],
    );
  });

  group('_onGetAudioRecorderStatusStream', () {
    final entity = AudioRecorderStatus(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    blocTest(
      'should call status stream and emit active state',
      build: () => AudioRecorderBloc(
        mockRequestRecordPermissionUsecase,
        mockStartRecordingUsecase,
        mockPauseRecorderUsecase,
        mockResumeRecorderUsecase,
        mockStopRecorderUsecase,
        mockGetPcmStreamUsecase,
        mockGetRecorderStatusStreamUsecase,
      ),
      setUp: () {
        when(
          () => mockGetRecorderStatusStreamUsecase(),
        ).thenAnswer((_) => Stream.value(entity));
      },
      act: (bloc) => bloc.add(GetAudioRecorderStatusStream()),
      verify: (bloc) {
        verify(() => mockGetRecorderStatusStreamUsecase());
      },
      expect: () => [isA<AudioRecorderStateActive>()],
    );
  });
}
