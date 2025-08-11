import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'get_onboarding_status_test.dart';

class MockSetOnboardingStatusUseCase extends Mock
    implements SetOnboardingStatusUseCase {}

void main() {
  test('should call set status and return data state', () async {
    final mockOnboardingRepository = MockOnboardingRepository();
    final setOnboardingStatusUseCase = SetOnboardingStatusUseCase(
      mockOnboardingRepository,
    );

    final data = DataSuccess(true);

    when(
      () => mockOnboardingRepository.setOnboardingStatus(),
    ).thenAnswer((_) async => data);

    final result = await setOnboardingStatusUseCase();

    expect(result, data);
    verify(() => mockOnboardingRepository.setOnboardingStatus());
    verifyNoMoreInteractions(mockOnboardingRepository);
  });
}
