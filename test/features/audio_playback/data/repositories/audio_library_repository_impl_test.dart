import 'dart:io';

import 'package:audiorecorder/core/constants/constants.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/audio_tag_helper.dart';
import 'package:audiorecorder/core/util/path_finder.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/permission_manager.dart';
import 'package:audiorecorder/features/audio_playback/data/datasources/platform_checker.dart';
import 'package:audiorecorder/features/audio_playback/data/models/audio_file_model.dart';
import 'package:audiorecorder/features/audio_playback/data/repositories/audio_library_repository_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class MockPermissionManager extends Mock implements PermissionManager {}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockPlatformChecker extends Mock implements PlatformChecker {}

class MockPathFinder extends Mock implements PathFinder {}

class MockAudioTagHelper extends Mock implements AudioTagHelper {}

class MockDirectory extends Mock implements Directory {}

final Map<String, dynamic> sampleAndroidInfoMap = {
  'version': {
    'baseOS': 'android-14',
    'codename': 'UpsideDownCake',
    'incremental': '12345',
    'previewSdkInt': null,
    'release': '14',
    'sdkInt': 34,
    'securityPatch': '2024-06-05',
  },
  'board': 'aosp_x86_64',
  'bootloader': 'unknown',
  'brand': 'google',
  'device': 'generic_x86_64',
  'display':
      'google/aosp_x86_64/x86_64:14/UPB4.230623.007/11100574:userdebug/dev-keys',
  'fingerprint':
      'google/aosp_x86_64/x86_64:14/UPB4.230623.007/11100574:userdebug/dev-keys',
  'hardware': 'ranchu',
  'host': 'abg-android-build-2544',
  'id': 'UPB4.230623.007',
  'manufacturer': 'Google',
  'model': 'sdk_gphone64_x86_64',
  'product': 'aosp_x86_64',
  'name': 'aosp_x86_64',
  'supported32BitAbis': [],
  'supported64BitAbis': ['x86_64'],
  'supportedAbis': ['x86_64'],
  'tags': 'dev-keys',
  'type': 'user',
  'isPhysicalDevice': false,
  'freeDiskSize': 12345678,
  'totalDiskSize': 23456789,
  'systemFeatures': ['android.hardware.audio.low_latency'],
  'serialNumber': 'unknown',
  'isLowRamDevice': false,
  'physicalRamSize': 4294967296,
  'availableRamSize': 2147483648,
};

void main() {
  final mockPermissionManager = MockPermissionManager();
  final mockDeviceInfoPlugin = MockDeviceInfoPlugin();
  final mockPlatformChecker = MockPlatformChecker();
  final mockPathFinder = MockPathFinder();
  final mockAudioTagHelper = MockAudioTagHelper();
  final mockExternalDirectory = MockDirectory();
  final mockAppDirectory = MockDirectory();

  final audioLibraryRepositoryImpl = AudioLibraryRepositoryImpl(
    mockDeviceInfoPlugin,
    mockPermissionManager,
    mockPlatformChecker,
    mockPathFinder,
    mockAudioTagHelper,
  );

  final androidInfo = AndroidDeviceInfo.fromMap(sampleAndroidInfoMap);

  group('requestReadAndWritePermission', () {
    test(
      'should call permission.audio when device is android with sdk >= 33',
      () async {
        when(() => mockPlatformChecker.isAndroid).thenReturn(true);
        when(
          () => mockDeviceInfoPlugin.androidInfo,
        ).thenAnswer((_) async => androidInfo);
        when(
          () => mockPermissionManager.requestPermission(Permission.audio),
        ).thenAnswer((_) async => true);

        final result = await audioLibraryRepositoryImpl
            .requestReadAndWritePermission();

        expect(result, isA<DataSuccess>());
      },
    );

    test(
      'should call permission.storage when device is not android or android with sdk <= 33',
      () async {
        when(() => mockPlatformChecker.isAndroid).thenReturn(false);
        when(
          () => mockPermissionManager.requestPermission(Permission.storage),
        ).thenAnswer((_) async => false);

        final result = await audioLibraryRepositoryImpl
            .requestReadAndWritePermission();

        expect(result, isA<DataFailure>());
      },
    );
  });

  group('getAllRecords', () {
    test('when external dir is null return DataFailure', () async {
      when(
        () => mockPathFinder.externalStorageDir,
      ).thenAnswer((_) async => null);
      final result = await audioLibraryRepositoryImpl.getAllRecords();

      expect(result, isA<DataFailure>());
    });

    test('should return AudioFileModels on success', () async {
      when(
        () => mockPathFinder.externalStorageDir,
      ).thenAnswer((_) async => mockExternalDirectory);
      when(() => mockExternalDirectory.path).thenReturn('');
      when(
        () => mockPathFinder.directory('/Recordings/$appName'),
      ).thenReturn(mockAppDirectory);

      when(() => mockAppDirectory.exists()).thenAnswer((_) async => true);

      when(() => mockAppDirectory.listSync()).thenReturn([]);

      final result = await audioLibraryRepositoryImpl.getAllRecords();

      expect(result, isA<DataSuccess>());
    });
  });

  group('deleteRecord', () {
    test('should return datasuccess on delete success', () async {
      final returnDir = MockDirectory();
      final model = AudioFileModel(
        title: "title",
        path: "path",
        createdAt: DateTime.now(),
        duration: Duration.zero,
      );

      when(
        () => mockPathFinder.directory(model.path),
      ).thenReturn(mockAppDirectory);
      when(
        () => mockAppDirectory.delete(recursive: true),
      ).thenAnswer((_) async => returnDir);

      final result = await audioLibraryRepositoryImpl.deleteAudioFile(model);

      expect(result, isA<DataSuccess>());
    });
  });
}
