//https://itnext.io/cross-platform-file-downloads-using-flutter-6723d40ee730

import 'package:file_picker/file_picker.dart';

import "web_download_service.dart"
    if (dart.library.io) "mobile_download_service.dart" as download_service;


Future<void> saveFile(
    {required String body, required String filename}) async {
  await download_service.saveFile(body: body, filename: filename);
}

Future<void> loadFile(
    {required String url, required PlatformFile file}) async {
  await download_service.loadFile(url: url, file: file);
}
