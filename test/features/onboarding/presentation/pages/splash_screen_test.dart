import 'package:audiorecorder/core/presentation/router/routes.dart';
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

void main() {
  final MockOnboardingBloc mockOnboardingBloc = MockOnboardingBloc();

  final sl = GetIt.instance;
  sl.registerFactory<OnboardingBloc>(() => mockOnboardingBloc);

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
