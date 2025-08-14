import 'package:audiorecorder/features/audio_playback/presentation/pages/audio_playback_screen.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/pages/audio_recorder_screen.dart';
import 'package:audiorecorder/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  static void pop(BuildContext context, [Object? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Future<dynamic> goToOnboardingScreen(
    BuildContext context, {
    dynamic argument,
    RouteReplacement routeReplacement = RouteReplacement.none,
  }) {
    return _toRoute(
      context,
      OnboardingScreen.path,
      routeReplacement,
      argument: argument,
    );
  }

  static Future<dynamic> goToAudioRecorderScreen(
    BuildContext context, {
    dynamic argument,
    RouteReplacement routeReplacement = RouteReplacement.none,
  }) {
    return _toRoute(
      context,
      AudioRecorderScreen.path,
      routeReplacement,
      argument: argument,
    );
  }

  static Future<dynamic> goToAudioPlaybackScreen(
    BuildContext context, {
    dynamic argument,
    RouteReplacement routeReplacement = RouteReplacement.none,
  }) {
    return _toRoute(
      context,
      AudioPlaybackScreen.path,
      routeReplacement,
      argument: argument,
    );
  }

  static Future<dynamic> _toRoute(
    BuildContext context,
    String route,
    RouteReplacement routeReplacement, {
    dynamic argument,
  }) {
    switch (routeReplacement) {
      case RouteReplacement.current:
        return Navigator.popAndPushNamed(context, route, arguments: argument);

      case RouteReplacement.all:
        return Navigator.pushReplacementNamed(
          context,
          route,
          arguments: argument,
        );
      case RouteReplacement.none:
        return Navigator.of(context).pushNamedAndRemoveUntil(
          route,
          (Route route) => false,
          arguments: argument,
        );
    }
  }
}

enum RouteReplacement { current, all, none }
