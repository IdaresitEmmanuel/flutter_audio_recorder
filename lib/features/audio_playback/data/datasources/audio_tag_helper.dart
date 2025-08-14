import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';


class AudioTagHelper {
  AudioMetadata read(File file) => readMetadata(file, getImage: false);
}
