import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingStatusUseCase implements Usecase<DataState<bool>, void> {
  final OnboardingRepository _onboardingRepository;
  SetOnboardingStatusUseCase(this._onboardingRepository);

  @override
  Future<DataState<bool>> call({void params}) {
    return _onboardingRepository.setOnboardingStatus();
  }
}
