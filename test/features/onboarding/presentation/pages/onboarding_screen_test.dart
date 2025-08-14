import 'package:audiorecorder/core/presentation/router/routes.dart';
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
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingBloc extends Mock implements OnboardingBloc {}

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

  late final MockOnboardingBloc mockOnboardingBloc;
  final sl = GetIt.instance;

  setUp(() {
    final pcmEntity = AudioRecorderPcm(timestamp: Duration.zero, data: []);
    final statusEntity = AudioRecorderStatus(
      isRecording: true,
      recordDuration: Duration.zero,
    );
    when(
      () => mockGetPcmStreamUsecase(),
    ).thenAnswer((_) => Stream.value(pcmEntity));
    when(
      () => mockGetRecorderStatusStreamUsecase(),
    ).thenAnswer((_) => Stream.value(statusEntity));

    mockOnboardingBloc = MockOnboardingBloc();
    sl.registerFactory<OnboardingBloc>(() => mockOnboardingBloc);

    sl.registerFactory<AudioRecorderBloc>(
      () => AudioRecorderBloc(
        mockRequestRecordPermissionUsecase,
        mockStartRecordingUsecase,
        mockPauseRecorderUsecase,
        mockResumeRecorderUsecase,
        mockStopRecorderUsecase,
        mockGetPcmStreamUsecase,
        mockGetRecorderStatusStreamUsecase,
      ),
    );
  });

  testWidgets('should save first lauch and navigate to recorder screen', (
    tester,
  ) async {
    // stub
    when(() => mockOnboardingBloc.add(SetOnboardingStatus())).thenReturn(null);

    // find widgets
    final getStartedButton = find.byKey(ValueKey('getstarted'));

    // execute tests
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
    await tester.tap(getStartedButton);

    // verify
    verify(() => mockOnboardingBloc.add(SetOnboardingStatus())).called(1);
    verifyNoMoreInteractions(mockOnboardingBloc);

    // trigger navigation
    await tester.pumpAndSettle();
    // verify navigation to recorder screen
    expect(find.byKey(ValueKey('audioRecorder')), findsOneWidget);
  });
}
