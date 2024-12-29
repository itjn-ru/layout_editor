//https://itnext.io/cross-platform-file-downloads-using-flutter-6723d40ee730

import 'dart:convert';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

Future<void> saveFile(
    {required String body, required String filename}) async {
  WebDownloadService downloadService = WebDownloadService();

  await downloadService.save(body: body, filename: filename);
}


class WebDownloadService {

  Future<void> save({required String body, required String filename}) async {


        await Future.delayed(const Duration(seconds: 1));

        String source = base64Encode(utf8.encode(body));

        final anchor = html.AnchorElement(
            href: 'data:application/octet-stream;base64,$source')
        ..download=filename
        ..click();
        //html.document.body!.append(anchor);

         // ..target = 'blank';
        //html.AnchorElement anchorElement =  html.AnchorElement(href: filename);
      //  print(await getDownloadsDirectory());
    // add the name
        //if (downloadName != null) {
        //anchor.download = filename;
        //}
        // trigger download
       // html.document.body!.append(anchor);
      //  anchor.click();
       // anchor.remove();



    //html.window.open(url, "_blank");
  }
}

class IdRepository {
  final html.Storage _localStorage = html.window.localStorage;

  Future save(String id) async {
    _localStorage['selected_id'] = id;
  }

  Future<String?> getId() async => _localStorage['selected_id'];

  Future invalidate() async {
    _localStorage.remove('selected_id');
  }
}

Future<void> loadFile(
    {required String url, required PlatformFile file}) async {
  WebUploadService uploadService = WebUploadService();
  await uploadService.load(
      url: url, file: file);
}

class WebUploadService {
  Future<void> load({required String url, required PlatformFile file}) async {
    Uri uri = Uri.parse(url);

    var request = http.MultipartRequest('POST', uri);


    final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        "file", file.bytes!.toList(),
        filename: file.name);
    request.files.add(multipartFile);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {}
    } catch (e) {}
  }
}


