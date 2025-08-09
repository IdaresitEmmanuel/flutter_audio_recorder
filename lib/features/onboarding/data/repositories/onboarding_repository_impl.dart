import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:audiorecorder/features/onboarding/data/models/onboarding_status_model.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final IOnboardingDatasource _onboardingDatasource;
  OnboardingRepositoryImpl(this._onboardingDatasource);

  @override
  Future<DataState<OnboardingStatusModel>> getOnboardingStatus() async {
    try {
      String? date = await _onboardingDatasource.getOnboardingDate();
      if (date == null) {
        return DataSuccess(
          OnboardingStatusModel(lastOnboardingCompletedAt: null),
        );
      } else {
        return DataSuccess(OnboardingStatusModel.fromIso8601String(date));
      }
    } catch (e) {
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<bool>> setOnboardingStatus() async {
    try {
      bool success = await _onboardingDatasource.setOnboardingDate(
        DateTime.now(),
      );
      if (success) {
        return DataSuccess(success);
      }
      throw Exception("Failired to set onboarding Date");
    } catch (e) {
      return DataFailure(DataError(value: e));
    }
  }
}
