import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_recorder/domain/entities/audio_save.dart';
import 'package:dartz/dartz.dart';

abstract class AudioStorageRepository {
  /// This function takes a nested list of audio data,
  /// converts it to a byte array, and writes it to a file.
  Future<DataState<Unit>> saveAudio(AudioSave audio);
}
