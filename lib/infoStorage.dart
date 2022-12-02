import 'dart:io';

import 'package:path_provider/path_provider.dart';

class InfoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/info.json');
  }

  Future<String> readInfo() async {
    try {
      final file = await _localFile;

      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }
}