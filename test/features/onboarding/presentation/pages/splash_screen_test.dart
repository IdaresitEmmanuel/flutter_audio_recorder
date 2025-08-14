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
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:bloc_test/bloc_test.dart';
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
  final MockOnboardingBloc mockOnboardingBloc = MockOnboardingBloc();
  final sl = GetIt.instance;
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
  // set up
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
  });
  group('_checkAndNavigate', () {
    testWidgets('should navigate to onboarding screen on first launch', (
      tester,
    ) async {
      whenListen(
        mockOnboardingBloc,
        Stream.fromIterable([
          OnboardingDone(OnboardingStatus(lastOnboardingCompletedAt: null)),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(),
          onGenerateRoute: Routes.onGenerateRoute,
        ),
      );

      // Check splash is shown
      expect(find.byKey(ValueKey('splash')), findsOneWidget);

      // Trigger navigation by emitting the state
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey('onboarding')), findsOneWidget);
    });
    testWidgets(
      'should navigate to recorder screen on 2nd and other launches',
      (tester) async {
        whenListen(
          mockOnboardingBloc,
          Stream.fromIterable([
            OnboardingDone(
              OnboardingStatus(lastOnboardingCompletedAt: DateTime.now()),
            ),
          ]),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: SplashScreen(),
            onGenerateRoute: Routes.onGenerateRoute,
          ),
        );

        // Check splash is shown
        expect(find.byKey(ValueKey('splash')), findsOneWidget);

        // Trigger navigation by emitting the state
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('audioRecorder')), findsOneWidget);
      },
    );
  });
}
