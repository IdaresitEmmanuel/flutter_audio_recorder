abstract class OnboardingEvent {
  const OnboardingEvent();
}

class GetOnboardingStatus extends OnboardingEvent {
  const GetOnboardingStatus();
}

class SetOnboardingStatus extends OnboardingEvent {
  const SetOnboardingStatus();
}
