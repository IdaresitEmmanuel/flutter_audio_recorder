import 'package:audiorecorder/core/presentation/router/routes.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingBloc extends Mock implements OnboardingBloc {}

void main() {
  late final MockOnboardingBloc mockOnboardingBloc;
  final sl = GetIt.instance;

  setUp(() {
    mockOnboardingBloc = MockOnboardingBloc();
    sl.registerFactory<OnboardingBloc>(() => mockOnboardingBloc);
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
    expect(find.byKey(ValueKey('audioPlayback')), findsOneWidget);
  });
}
