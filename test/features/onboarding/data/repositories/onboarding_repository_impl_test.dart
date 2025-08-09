import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:audiorecorder/features/onboarding/data/models/onboarding_status_model.dart';
import 'package:audiorecorder/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIOnboardingDatasource extends Mock implements IOnboardingDatasource {}

void main() {
  final mockOnboardingDataSource = MockIOnboardingDatasource();
  final onboardingRepoImpl = OnboardingRepositoryImpl(mockOnboardingDataSource);

  group('getOnboardingStatus', () {
    test('should return DataSuccess Object on success', () async {
      final dateString = DateTime.now().toIso8601String();
      when(
        () => mockOnboardingDataSource.getOnboardingDate(),
      ).thenAnswer((_) async => dateString);

      final result = await onboardingRepoImpl.getOnboardingStatus();

      expect(result, isA<DataSuccess<OnboardingStatusModel>>());
      verify(() => mockOnboardingDataSource.getOnboardingDate());
    });

    test('should return DataSuccess Object on success', () async {
      final dateString = DateTime.now().toIso8601String();
      when(
        () => mockOnboardingDataSource.getOnboardingDate(),
      ).thenAnswer((_) async => dateString);

      final result = await onboardingRepoImpl.getOnboardingStatus();

      expect(result, isA<DataSuccess<OnboardingStatusModel>>());
      verify(() => mockOnboardingDataSource.getOnboardingDate());
    });
  });

  group('setOnboardingStatus', () {
    test('should return DataSucess on success', () async {
      when(
        () => mockOnboardingDataSource.setOnboardingDate(any()),
      ).thenAnswer((_) async => true);

      final result = await onboardingRepoImpl.setOnboardingStatus();

      expect(result, isA<DataSuccess>());
      verify(() => mockOnboardingDataSource.setOnboardingDate(any()));
    });
    test('should return DataFailure on error', () async {
       when(
        () => mockOnboardingDataSource.setOnboardingDate(any()),
      ).thenAnswer((_) async => false);

      final result = await onboardingRepoImpl.setOnboardingStatus();

      expect(result, isA<DataFailure>());
      verify(() => mockOnboardingDataSource.setOnboardingDate(any()));
    });
  });
}
