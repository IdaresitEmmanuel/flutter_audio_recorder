import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class GetOnboardingStatus extends OnboardingEvent {
  const GetOnboardingStatus();

  @override
  List<Object?> get props => [];
}

class SetOnboardingStatus extends OnboardingEvent {
  const SetOnboardingStatus();

  @override
  List<Object?> get props => [];
}
