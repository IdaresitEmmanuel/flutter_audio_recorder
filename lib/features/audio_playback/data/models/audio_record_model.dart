import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';

class AudioFileModel extends AudioFile {
  const AudioFileModel({
    required super.title,
    required super.path,
    required super.createdAt,
    required super.duration,
  });
}
