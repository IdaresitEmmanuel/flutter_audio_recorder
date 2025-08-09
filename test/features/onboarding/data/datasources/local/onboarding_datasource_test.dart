import 'package:audiorecorder/core/constants/constants.dart';
import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('getOnboardingDate', () {
    final mockSharedPreferences = MockSharedPreferences();
    final onboardingDatasource = OnboardingDatasource(mockSharedPreferences);
    test('should return an iso1806String or null', () async {
      final date = DateTime.now();
      when(
        () => mockSharedPreferences.getString(onboardingDateKey),
      ).thenReturn(date.toIso8601String());

      final result = await onboardingDatasource.getOnboardingDate();

      expect(result, date.toIso8601String());
      verify(() => mockSharedPreferences.getString(onboardingDateKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });

  group('setOnboardingDate', () {
    final mockSharedPreferences = MockSharedPreferences();
    final onboardingDatasource = OnboardingDatasource(mockSharedPreferences);
    test('should return a boolean', () async {
      final date = DateTime.now();
      when(
        () => mockSharedPreferences.setString(
          onboardingDateKey,
          date.toIso8601String(),
        ),
      ).thenAnswer((_) async => true);

      final result = await onboardingDatasource.setOnboardingDate(date);

      expect(result, isA<bool>());

      verify(
        () => mockSharedPreferences.setString(
          onboardingDateKey,
          date.toIso8601String(),
        ),
      );
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
