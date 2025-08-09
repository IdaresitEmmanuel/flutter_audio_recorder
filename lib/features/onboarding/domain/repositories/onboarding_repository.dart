import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';

abstract class OnboardingRepository {
  Future<DataState<OnboardingStatus>> getOnboardingStatus();
  Future<DataState<bool>> setOnboardingStatus();
}
