import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/usecase/usecase.dart';
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase
    implements Usecase<DataState<OnboardingStatus>, void> {
  final OnboardingRepository _onboardingRepository;
  GetOnboardingStatusUseCase(this._onboardingRepository);

  @override
  Future<DataState<OnboardingStatus>> call({void params}) {
    return _onboardingRepository.getOnboardingStatus();
  }
}
