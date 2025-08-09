import 'package:audiorecorder/features/onboarding/data/models/onboarding_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create an OnboardingStatusModel', () {
    final model = OnboardingStatusModel(
      lastOnboardingCompletedAt: DateTime.now(),
    );
    expect(model, isA<OnboardingStatusModel>());
  });

  group('OnboardingStatusModel.fromIso8601String', () {
    test('should create an OnboardingSatusModel from an Iso8601String', () {
      final model = OnboardingStatusModel.fromIso8601String(
        DateTime.now().toIso8601String(),
      );

      expect(model, isA<OnboardingStatusModel>());
    });

    test(
      'should throw a FormatException when wrong Iso8601String is provided',
      () {
        expect(()=>
          OnboardingStatusModel.fromIso8601String("wrong string"),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
