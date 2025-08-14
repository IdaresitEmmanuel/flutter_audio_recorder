import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audiorecorder/core/constants/constants.dart';
import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_tag_helper.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/path_finder.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/permission_manager.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/platform_checker.dart';
import 'package:audiorecorder/features/audio_playback/data/models/audio_record_model.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:audiorecorder/features/audio_playback/domain/repositories/audio_library_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioLibraryRepositoryImpl implements AudioLibraryRepository {
  final PermissionManager _permissionManager;
  final DeviceInfoPlugin _deviceInfoPlugin;
  final PlatformChecker _platformChecker;
  final PathFinder _pathFinder;
  final AudioTagHelper _audioTags;

  AudioLibraryRepositoryImpl(
    this._deviceInfoPlugin,
    this._permissionManager,
    this._platformChecker,
    this._pathFinder,
    this._audioTags,
  );

  @override
  Future<DataState<Unit>> requestReadAndWritePermission() async {
    try {
      bool isPermissionGranted;
      if (_platformChecker.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        // For Android 13 (API 33) and above, use specific media permissions.
        if (androidInfo.version.sdkInt >= 33) {
          isPermissionGranted = await _permissionManager.requestPermission(
            Permission.audio,
          );
        } else {
          // For Android versions below 13, use the general storage permission.
          isPermissionGranted = await _permissionManager.requestPermission(
            Permission.storage,
          );
        }
      } else {
        // For other platforms (e.g., iOS), request the storage permission.
        isPermissionGranted = await _permissionManager.requestPermission(
          Permission.storage,
        );
      }

      if (isPermissionGranted) {
        return DataSuccess(unit);
      }
      return DataFailure(DataError(value: 'storage permission not granted'));
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<List<AudioFileModel>>> getAllRecords() async {
    try {
      final Directory? extDir = await _pathFinder.externalStorageDir;

      if (extDir == null) {
        return DataFailure(
          DataError(value: 'Unable to access external storage'),
        );
      }

      final String appDirPath = '${extDir.path}/Recordings/$appName';
      final Directory appDir = _pathFinder.directory(appDirPath);

      if (!await appDir.exists()) {
        // if folder is empty
        return DataSuccess([]);
      }

      final List<FileSystemEntity> entities = appDir.listSync();
      final List<File> audioFiles = entities
          .where((entity) => entity is File && entity.path.endsWith('.wav'))
          .map((entity) => entity as File)
          .toList();

      List<AudioFileModel> audioFileModels = [];

      for (var audioFile in audioFiles) {
        String path = audioFile.path;
        String title = path.split('/').last;
        DateTime createdAt = await audioFile.lastModified();
        AudioMetadata tag = _audioTags.read(audioFile);
        Duration duration = tag.duration ?? Duration.zero;

        final model = AudioFileModel(
          title: title,
          path: path,
          createdAt: createdAt,
          duration: duration,
        );
        audioFileModels.add(model);
      }

      return DataSuccess(audioFileModels);
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }

  @override
  Future<DataState<Unit>> deleteAudioFile(AudioFile record) async {
    try {
      await _pathFinder.directory(record.path).delete(recursive: true);
      return DataSuccess(unit);
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }
}
