import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:audiorecorder/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Shared Preferences
  sl.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  // Data Sources
  sl.registerSingleton<IOnboardingDatasource>(OnboardingDatasource(sl()));

  // Repositories
  sl.registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<GetOnboardingStatusUseCase>(
    GetOnboardingStatusUseCase(sl()),
  );
  sl.registerSingleton<SetOnboardingStatusUseCase>(
    SetOnboardingStatusUseCase(sl()),
  );

  // Blocs
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(sl(), sl()));
}
