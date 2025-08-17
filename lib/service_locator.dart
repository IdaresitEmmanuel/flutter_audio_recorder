import 'package:audioplayers/audioplayers.dart';
import 'package:audiorecorder/core/platform_channels/platform_channels.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_player_service.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_tag_helper.dart';
import 'package:audiorecorder/core/util/path_finder.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/permission_manager.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/platform_checker.dart';
import 'package:audiorecorder/features/audio_playback/data/repositories/audio_library_repository_impl.dart';
import 'package:audiorecorder/features/audio_playback/data/repositories/audio_playback_repository_impl.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_playback_repository.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/delete_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_files.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/get_audio_playback_status_stream.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/pause_audio_player.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/play_audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/request_storage_permission.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/seek_to_position.dart';
import 'package:audiorecorder/features/audio_playback/domain/usecases/stop_audio_player.dart';
import 'package:audiorecorder/features/audio_playback/presentation/bloc/audio_playback_bloc.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/audio_recorder_service.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/wave_codec_helper.dart';
import 'package:audiorecorder/features/audio_recorder/data/repositories/audio_recorder_repository_impl.dart';
import 'package:audiorecorder/features/audio_recorder/data/repositories/audio_storage_repository_impl.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_recorder_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_storage_repository.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_pcm_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/get_recorder_status_stream.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/pause_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/request_record_permission.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/resume_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/save_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/start_recording.dart';
import 'package:audiorecorder/features/audio_recorder/domain/usecases/stop_recorder.dart';
import 'package:audiorecorder/features/audio_recorder/presentation/bloc/audio_recorder_bloc.dart';
import 'package:audiorecorder/features/onboarding/data/datasources/local/onboarding_datasource.dart';
import 'package:audiorecorder/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:audiorecorder/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  // Device Info Plugin
  sl.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());
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
  // audio recorder
  sl.registerSingleton<WaveCodecHelper>(WaveCodecHelper());
  // audio playback
  sl
    ..registerSingleton<AudioTagHelper>(AudioTagHelper())
    ..registerSingleton<PathFinder>(PathFinder())
    ..registerSingleton<PermissionManager>(PermissionManager.instance)
    ..registerSingleton<PlatformChecker>(PlatformChecker())
    ..registerSingleton<AudioPlayer>(AudioPlayer());
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
  // Audio Playback
  sl.registerSingleton<IAudioPlayerService>(AudioPlayerService(sl()));
}

_registerRepositories() {
  // Onboarding
  sl.registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl(sl()));
  // Audio Recorder
  sl
    ..registerSingleton<AudioRecorderRepository>(
      AudioRecorderRepositoryImpl(sl()),
    )
    ..registerSingleton<AudioStorageRepository>(
      AudioStorageRepositoryImpl(sl(), sl()),
    );
  // Audio Playback
  sl
    ..registerSingleton<AudioLibraryRepository>(
      AudioLibraryRepositoryImpl(sl(), sl(), sl(), sl(), sl()),
    )
    ..registerSingleton<AudioPlaybackRepository>(
      AudioPlaybackRepositoryImpl(sl()),
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
    )
    ..registerSingleton<SaveRecordingUsecase>(SaveRecordingUsecase(sl()));
  // Audio Playback
  sl
    ..registerSingleton<RequestStoragePermissionUsecase>(
      RequestStoragePermissionUsecase(sl()),
    )
    ..registerSingleton<GetAudioFilesUsecase>(GetAudioFilesUsecase(sl()))
    ..registerSingleton<DeleteAudioFileUsecase>(DeleteAudioFileUsecase(sl()))
    ..registerSingleton<PlayAudioFileUsecase>(PlayAudioFileUsecase(sl()))
    ..registerSingleton<PauseAudioPlayerUsecase>(PauseAudioPlayerUsecase(sl()))
    ..registerSingleton<SeekToPositionUsecase>(SeekToPositionUsecase(sl()))
    ..registerSingleton<StopAudioPlayerUsecase>(StopAudioPlayerUsecase(sl()))
    ..registerSingleton<GetAudioPlaybackStatusStreamUsecase>(
      GetAudioPlaybackStatusStreamUsecase(sl()),
    );
}

_registerBlocs() {
  // Onboarding
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(sl(), sl()));
  // Audio Recorder
  sl.registerFactory<AudioRecorderBloc>(
    () => AudioRecorderBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  // Audio Playback
  sl.registerFactory<AudioPlaybackBloc>(
    () => AudioPlaybackBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
}
