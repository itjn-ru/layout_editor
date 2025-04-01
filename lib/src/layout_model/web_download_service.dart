//https://itnext.io/cross-platform-file-downloads-using-flutter-6723d40ee730

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:web/web.dart';


Future<void> saveFile(
    {required String body, required String filename}) async {
  WebDownloadService downloadService = WebDownloadService();

  await downloadService.save(body: body, filename: filename);
}


class WebDownloadService {

  Future<void> save({required String body, required String filename}) async {

 String source = base64Encode(utf8.encode(body));
HTMLAnchorElement()
      ..href = 'data:application/octet-stream;base64,$source'
      ..download = filename
      ..click();
  }
}

// class IdRepository {
//   final html.Storage _localStorage = html.window.localStorage;

//   Future save(String id) async {
//     _localStorage['selected_id'] = id;
//   }

//   Future<String?> getId() async => _localStorage['selected_id'];

//   Future invalidate() async {
//     _localStorage.remove('selected_id');
//   }
// }

Future<void> loadFile(
    {required String url, required PlatformFile file}) async {
  WebUploadService uploadService = WebUploadService();
  await uploadService.load(
      url: url, file: file);
}

class WebUploadService {
  Future<void> load({required String url, required PlatformFile file}) async {
  /*  Uri uri = Uri.parse(url);

    var request = MultipartRequest('POST', uri);


    final MultipartFile multipartFile = MultipartFile.fromBytes(
        "file", file.bytes!.toList(),
        filename: file.name);
    request.files.add(multipartFile);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {}
    } catch (e) {}*/
  }
}


