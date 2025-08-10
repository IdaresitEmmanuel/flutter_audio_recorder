import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetOnboardingStatusUseCase extends Mock
    implements GetOnboardingStatusUseCase {}

class MockSetOnboardingStatusUseCase extends Mock
    implements SetOnboardingStatusUseCase {}

void main() {
  final mockGetOnboardingStatusUseCase = MockGetOnboardingStatusUseCase();
  final mockSetOnboardingStatusUseCase = MockSetOnboardingStatusUseCase();

  test('Emits OnboardingLoading() initial state', () {
    final onboardingBloc = OnboardingBloc(
      mockGetOnboardingStatusUseCase,
      mockSetOnboardingStatusUseCase,
    );

    expect(onboardingBloc.state, OnboardingLoading());
  });

  group("GetOnboardingStatus", () {
    final dataSuccess = DataSuccess(
      OnboardingStatus(lastOnboardingCompletedAt: DateTime.now()),
    );
    final dataFailure = DataFailure<OnboardingStatus>(
      DataError(value: "failed"),
    );

    blocTest(
      'should emit the OnboardingDone state on GetOnboardingStatus event success',
      build: () => OnboardingBloc(
        mockGetOnboardingStatusUseCase,
        mockSetOnboardingStatusUseCase,
      ),
      setUp: () {
        when(
          () => mockGetOnboardingStatusUseCase(),
        ).thenAnswer((_) async => dataSuccess);
      },
      act: (bloc) => bloc.add(GetOnboardingStatus()),
      expect: () => [OnboardingDone(dataSuccess.data!)],
    );

    blocTest(
      'should emit the OnboardingError state on GetOnboardingStatus event fail',
      build: () => OnboardingBloc(
        mockGetOnboardingStatusUseCase,
        mockSetOnboardingStatusUseCase,
      ),
      setUp: () {
        when(
          () => mockGetOnboardingStatusUseCase(),
        ).thenAnswer((_) async => dataFailure);
      },
      act: (bloc) => bloc.add(GetOnboardingStatus()),
      expect: () => [isA<OnboardingError>()],
    );
  });

  blocTest(
    'should call SetOnboardingStatusUseCase on onSetOnboardingStatus',
    build: () => OnboardingBloc(
      mockGetOnboardingStatusUseCase,
      mockSetOnboardingStatusUseCase,
    ),
    setUp: (){
       when(
          () => mockSetOnboardingStatusUseCase(),
        ).thenAnswer((_) async => DataSuccess(true));
    },
    act: (bloc) => bloc.add(SetOnboardingStatus()),

    verify: (bloc) => verify(() => mockSetOnboardingStatusUseCase()),
  );
}
