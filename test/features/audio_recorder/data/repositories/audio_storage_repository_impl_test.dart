import 'dart:io';

import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/path_finder.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/wave_codec_helper.dart';
import 'package:audiorecorder/features/audio_recorder/data/repositories/audio_storage_repository_impl.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_recorder_pcm.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWaveCodecHelper extends Mock implements WaveCodecHelper {}

class MockPathFinder extends Mock implements PathFinder {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

void main() {
  final mockWaveCodecHelper = MockWaveCodecHelper();
  final mockPathFinder = MockPathFinder();

  final audioStorageRepositoryImpl = AudioStorageRepositoryImpl(
    mockWaveCodecHelper,
    mockPathFinder,
  );

  group('saveAudio', () {
    test('should process and save AudioSave data', () async {
      final mockFile = MockFile();
      final mockDirectory = MockDirectory();
      final audioSave = AudioSave(
        data: [
          AudioRecorderPcm(
            timestamp: Duration.zero,
            data: [0.00037262, -0.003837],
          ),
        ],
        title: 'Record 01',
      );

      when(
        () => mockWaveCodecHelper.buildWavHeader(any()),
      ).thenReturn(Uint8List(30));

      when(
        () => mockPathFinder.externalStorageDir,
      ).thenAnswer((_) async => mockDirectory);

      when(() => mockDirectory.path).thenReturn('/path');

      when(() => mockPathFinder.file(any())).thenReturn(mockFile);

      when(
        () => mockFile.create(recursive: true),
      ).thenAnswer((_) async => File(''));
      when(
        () => mockFile.writeAsBytes(any()),
      ).thenAnswer((_) async => File(''));

      final result = await audioStorageRepositoryImpl.saveAudio(audioSave);

      expect(result, isA<DataSuccess>());
      verify(() => mockWaveCodecHelper.buildWavHeader(any()));
      verify(() => mockPathFinder.externalStorageDir);
      verify(() => mockDirectory.path);
      verify(() => mockPathFinder.file(any()));
      verify(() => mockFile.writeAsBytes(any()));
    });
  });
}
