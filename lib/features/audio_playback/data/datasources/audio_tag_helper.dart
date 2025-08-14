import 'package:audiotags/audiotags.dart';

class AudioTagHelper {
  Future<Tag?> read(String path) => AudioTags.read(path);
}
