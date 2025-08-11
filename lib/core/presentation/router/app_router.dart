import 'package:audiorecorder/features/audio_recorder/presentation/pages/audio_recorder_screen.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  static void pop(BuildContext context, [Object? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Future<dynamic> goToOnboardingScreen(BuildContext context) {
    return Navigator.pushNamed(context, OnboardingScreen.path);
  }

  static Future<dynamic> goToAudioRecorderScreen(BuildContext context) {
    return Navigator.pushNamed(context, AudioRecorderScreen.path);
  }
}
