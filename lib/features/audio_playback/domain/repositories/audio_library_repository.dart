import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:dartz/dartz.dart';

abstract class AudioLibraryRepository {
  Future<DataState<Unit>> requestReadAndWritePermission();
  Future<DataState<List<AudioFile>>> getAllRecords();
  Future<DataState<Unit>> deleteAudioFile(AudioFile record);
}
