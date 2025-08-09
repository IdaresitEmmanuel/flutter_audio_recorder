import 'package:equatable/equatable.dart';

class OnboardingStatus extends Equatable {
  final DateTime? lastOnboardingCompletedAt;

  const OnboardingStatus({required this.lastOnboardingCompletedAt});

  @override
  List<Object?> get props => [lastOnboardingCompletedAt];
}
