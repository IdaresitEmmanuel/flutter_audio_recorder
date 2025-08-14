import 'package:audiorecorder/features/audio_playback/presentation/pages/audio_playback_screen.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/pages/audio_recorder_screen.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnboardingScreen.path:
        return _pageRoute(const OnboardingScreen(), settings);
      case AudioRecorderScreen.path:
        return _pageRoute(const AudioRecorderScreen(), settings);
      case AudioPlaybackScreen.path:
        return _pageRoute(const AudioPlaybackScreen(), settings);
      case SplashScreen.path:
      default:
        return _pageRoute(const SplashScreen(), settings);
    }
  }

  static Route<dynamic> _pageRoute(Widget screen, [RouteSettings? settings]) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      settings: settings,
    );
  }
}
