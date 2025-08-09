import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';

class OnboardingStatusModel extends OnboardingStatus {
  const OnboardingStatusModel({required super.lastOnboardingCompletedAt});

  /// Throws a [FormatException] if the input string cannot be parsed.
  factory OnboardingStatusModel.fromIso8601String(String iso8601String) {
    final date = DateTime.parse(iso8601String);
    return OnboardingStatusModel(lastOnboardingCompletedAt: date);
  }
}
