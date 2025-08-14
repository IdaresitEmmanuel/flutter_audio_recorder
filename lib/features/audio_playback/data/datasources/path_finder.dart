import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathFinder {
  Future<Directory?> get externalStorageDir => getExternalStorageDirectory();

  Directory directory(String path) => Directory(path);
}
