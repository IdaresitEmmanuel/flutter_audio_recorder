import 'package:audiorecorder/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IOnboardingDatasource {
  /// Returns an Iso80601String
  Future<String?> getOnboardingDate();
  Future<bool> setOnboardingDate(DateTime date);
}

class OnboardingDatasource extends IOnboardingDatasource {
  final SharedPreferences _sharedPreferences;
  OnboardingDatasource(this._sharedPreferences);

  @override
  Future<String?> getOnboardingDate() async {
    return _sharedPreferences.getString(onboardingDateKey);
  }

  @override
  Future<bool> setOnboardingDate(DateTime date) {
    return _sharedPreferences.setString(
      onboardingDateKey,
      date.toIso8601String(),
    );
  }
}
