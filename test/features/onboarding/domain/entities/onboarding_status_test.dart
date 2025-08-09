import 'package:audiorecorder/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final entity = OnboardingStatus(lastOnboardingCompletedAt: DateTime.now());

  test('should create an OnboardingStatus entity', () {
    expect(entity, isA<OnboardingStatus>());
  });
}
