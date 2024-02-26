//https://itnext.io/cross-platform-file-downloads-using-flutter-6723d40ee730


import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


Future<void> saveFile(
    {required String body, required String filename}) async {
  MobileDownloadService downloadService = MobileDownloadService();
  await downloadService.save(body: body, filename: filename);
}

class MobileDownloadService {

  Future<void> save({required String body, required String filename}) async {
    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    // gets the directory where we will download the file.
    var dir = await getApplicationDocumentsDirectory();
    //var dir = await getDownloadsDirectory();

    // You should put the name you want for the file here.
    // Take in account the extension.
    //String fileName = 'myFile';

    // downloads the file

    Uri uriDocuments = Uri.parse(body);

    Dio dio = Dio();
    await dio.downloadUri(uriDocuments, "${dir.path}/$filename",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',

          },
        ));

    // opens the file
    OpenFile.open("${dir.path}/$filename");//, type: 'application/octet-stream');
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}

Future<void> loadFile(
    {required String url, required PlatformFile file}) async {
  MobileUploadService uploadService = MobileUploadService();
  await uploadService.load(
      url: url, file: file);
}

class MobileUploadService {
  @override
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
    /*
    final uri = Uri.parse('https://myendpoint.com');
    var request = new http.MultipartRequest('POST', uri);
    final httpImage = http.MultipartFile.fromBytes('files.myimage', bytes,
        contentType: MediaType.parse(mimeType), filename: 'myImage.png');
    request.files.add(httpImage);
    final response = await request.send();

        (String filename, String url) async {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
          await http.MultipartFile.fromPath(
              'pdf',
              filename
          )
      );
      var res = await request.send();
    }
*/
  }
}

/*
class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key, required this.url}) : super(key: key);

  final String url;

  Future<void> _downloadFile() async {
    DownloadService downloadService =
    kIsWeb ? WebDownloadService() : MobileDownloadService();
    await downloadService.download(url: url);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _downloadFile,
      icon: const Icon(Icons.download),
      label: const Text('Download'),
    );
  }
}
*/
