// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/router/app_router.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const path = '/splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _streamSubscription;
  @override
  void initState() {
    super.initState();

    _checkAndNavigate();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  _checkAndNavigate() async {
    await Future.delayed(Duration(seconds: 2));
    final bloc = sl.get<OnboardingBloc>();
    _streamSubscription?.cancel();
    _streamSubscription = bloc.stream.listen((state) {
      if (state is OnboardingDone) {
        if (!context.mounted) return;
        if (state.status?.lastOnboardingCompletedAt == null) {
          // go to onboarding screen
          AppRouter.goToOnboardingScreen(context);
        } else {
          // go to main screen
          AppRouter.goToAudioRecorderScreen(context);
        }
      }
    });
    bloc.add(GetOnboardingStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('splash'),
      body: Center(child: Image.asset(AppAssets.images.echoLogo)),
    );
  }
}
