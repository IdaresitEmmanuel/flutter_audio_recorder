import 'package:audiorecorder/core/platform_channels/platform_channels.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/audio_recorder_service.dart';
import 'package:audiorecorder/features/audio_recorder/data/repositories/audio_recorder_repository_impl.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:audiorecorder/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // License
  _registerLicenses();

  await _registerServices();
  // Data Sources
  _registerAPIs();
  // Repositories
  _registerRepositories();
  // UseCases
  _registerUsecases();

  // Blocs
  _registerBlocs();
}

_registerLicenses() {
  LicenseRegistry.addLicense(() async* {
    final interLicense = await rootBundle.loadString(
      'assets/fonts/Inter/OFL.txt',
    );
    // ignore: non_constant_identifier_names
    final DMSerifTextLicense = await rootBundle.loadString(
      'assets/fonts/DM_Serif_Text/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['google_fonts'], interLicense);
    yield LicenseEntryWithLineBreaks(['google_fonts'], DMSerifTextLicense);
  });
}

Future<void> _registerServices() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  // Method Channels
  sl.registerSingleton<MethodChannel>(PlatformChannels.methodChannel);
  // Event Channels
  sl
    ..registerSingleton<EventChannel>(
      PlatformChannels.audioRecorderPcmEventChannel,
      instanceName: 'audioRecorderPcmEventChannel',
    )
    ..registerSingleton<EventChannel>(
      PlatformChannels.audioRecorderStateEventChannel,
      instanceName: 'audioRecorderStateEventChannel',
    );
}

_registerAPIs() {
  // Onboarding
  sl.registerSingleton<IOnboardingDatasource>(OnboardingDatasource(sl()));
  // Audio Recorder
  sl.registerSingleton<IAudioRecorderService>(
    AudioRecorderService(
      sl(),
      sl(instanceName: 'audioRecorderPcmEventChannel'),
      sl(instanceName: 'audioRecorderStateEventChannel'),
    ),
  );
}

_registerRepositories() {
  // Onboarding
  sl.registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl(sl()));
  // Audio Recorder
  sl.registerSingleton<AudioRecorderRepository>(
    AudioRecorderRepositoryImpl(sl()),
  );
}

_registerUsecases() {
  // Onboarding
  sl
    ..registerSingleton<GetOnboardingStatusUseCase>(
      GetOnboardingStatusUseCase(sl()),
    )
    ..registerSingleton<SetOnboardingStatusUseCase>(
      SetOnboardingStatusUseCase(sl()),
    );
  // Audio Recorder
  sl
    ..registerSingleton<RequestRecordPermissionUsecase>(
      RequestRecordPermissionUsecase(sl()),
    )
    ..registerSingleton<StartRecordingUsecase>(StartRecordingUsecase(sl()))
    ..registerSingleton<PauseRecorderUsecase>(PauseRecorderUsecase(sl()))
    ..registerSingleton<ResumeRecorderUsecase>(ResumeRecorderUsecase(sl()))
    ..registerSingleton<StopRecorderUsecase>(StopRecorderUsecase(sl()))
    ..registerSingleton<GetPcmStreamUsecase>(GetPcmStreamUsecase(sl()))
    ..registerSingleton<GetRecorderStatusStreamUsecase>(
      GetRecorderStatusStreamUsecase(sl()),
    );
}

_registerBlocs() {
  // Onboarding
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(sl(), sl()));
  // Audio Recorder
  sl.registerFactory<AudioRecorderBloc>(
    () => AudioRecorderBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
}
