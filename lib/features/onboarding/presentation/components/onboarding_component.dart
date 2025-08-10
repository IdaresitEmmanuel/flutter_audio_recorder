import 'package:audiorecorder/core/presentation/assets/app_assets.dart';
import 'package:audiorecorder/core/presentation/theme/colors.dart';
import 'package:audiorecorder/core/presentation/theme/dimensions.dart';
import 'package:audiorecorder/core/presentation/widgets/app_action_button.dart';
import 'package:audiorecorder/core/presentation/widgets/echo_scaffold.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';

class OnboardingComponent extends StatefulWidget {
  const OnboardingComponent({super.key});

  @override
  State<OnboardingComponent> createState() => _OnboardingComponentState();
}

class _OnboardingComponentState extends State<OnboardingComponent> {
  @override
  Widget build(BuildContext context) {
    return EchoScaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              AppAssets.images.waveForm,
              width: double.maxFinite,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pageMargin,
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Capture every thought,\n",
                  style: Theme.of(context).textTheme.headlineMedium,

                  children: [
                    TextSpan(
                      text: "instantly",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontFamily: "DMSerifText",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pageMargin,
              ),
              child: Text(
                "Record, replay and remember anytime",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 123),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pageMargin,
              ),
              child: AppActionButton(
                onPressed: () {
                  sl.get<OnboardingBloc>().add(SetOnboardingStatus());
                  // TODO: Go to Recording Screen
                },
                text: "Get Started",
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
