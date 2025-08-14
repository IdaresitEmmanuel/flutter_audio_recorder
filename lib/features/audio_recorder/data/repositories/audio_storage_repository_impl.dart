import 'dart:io';
import 'dart:typed_data';

import 'package:audiorecorder/core/constants/constants.dart';
import 'package:audiorecorder/core/resources/data_error.dart';
import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/core/util/echo_logger.dart';
import 'package:audiorecorder/core/util/path_finder.dart';
import 'package:audiorecorder/features/audio_recorder/data/datasources/wave_codec_helper.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:audiorecorder/features/audio_recorder/domain/repositories/audio_storage_repository.dart';
import 'package:dartz/dartz.dart';

class AudioStorageRepositoryImpl implements AudioStorageRepository {
  final WaveCodecHelper _waveCodecHelper;
  final PathFinder _pathFinder;
  AudioStorageRepositoryImpl(this._waveCodecHelper, this._pathFinder);

  @override
  Future<DataState<Unit>> saveAudio(AudioSave audio) async {
    try {
      // Flatten the pcm List into a single List of doubles.
      final List<double> flattenedData = audio.data
          .expand((pcm) => pcm.data)
          .toList();

      // Convert the double data to a 16-bit signed integer format (Int16).
      final Int16List int16Data = Int16List(flattenedData.length);
      for (int i = 0; i < flattenedData.length; i++) {
        double value = flattenedData[i].clamp(-1.0, 1.0);
        int16Data[i] = (value * 32767).toInt();
      }

      // Convert the Int16List to a Uint8List (byte array) for writing.
      final Uint8List audioBytes = int16Data.buffer.asUint8List();

      // Build the WAV header.
      final Uint8List headerBytes = _waveCodecHelper.buildWavHeader(
        audioBytes.length,
      );

      // Combine the header and audio data into a single list of bytes.
      final Uint8List fullFileBytes = Uint8List.fromList(
        headerBytes + audioBytes,
      );

      // Get a temporary directory to store the file and write the data.
      final Directory? tempDir = await _pathFinder.externalStorageDir;
      if (tempDir == null) {
        return DataFailure(DataError(value: 'No storage access'));
      }
      final String filePath =
          '${tempDir.path}$audioStoragePath/${audio.title}.wav';
      final File file = _pathFinder.file(filePath);

      await file.writeAsBytes(fullFileBytes);
      return DataSuccess(unit);
    } catch (e) {
      EchoLogger.e(e);
      return DataFailure(DataError(value: e));
    }
  }
}
