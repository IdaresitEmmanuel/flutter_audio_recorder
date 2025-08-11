import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  test('should call get status and return data state', () async {
    final mockOnboardingRepository = MockOnboardingRepository();
    final getOnboardingStatusUseCase = GetOnboardingStatusUseCase(
      mockOnboardingRepository,
    );
    final data = DataSuccess(
      OnboardingStatus(lastOnboardingCompletedAt: DateTime.now()),
    );
    // set up
    when(
      () => mockOnboardingRepository.getOnboardingStatus(),
    ).thenAnswer((_) async => data);

    // act

    final result = await getOnboardingStatusUseCase();

    // verify

    expect(result, data);
    verify(() => mockOnboardingRepository.getOnboardingStatus());
    verifyNoMoreInteractions(mockOnboardingRepository);
  });
}
