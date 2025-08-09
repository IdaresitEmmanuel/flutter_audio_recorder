import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  final OnboardingStatus? status;
  final DataError? error;

  const OnboardingState({this.status, this.error});

  @override
  List<Object> get props => [status!, error!];
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingDone extends OnboardingState {
  const OnboardingDone(OnboardingStatus status) : super(status: status);
}

class OnboardingError extends OnboardingState {
  const OnboardingError(DataError error) : super(error: error);
}
