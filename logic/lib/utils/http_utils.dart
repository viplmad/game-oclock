import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';

class HttpUtils {
  const HttpUtils._();

  static Future<MultipartFile> createMultipartImageFile(
    String imagePath,
  ) async {
    final Uint8List bytes = await File(imagePath).readAsBytes();
    final MultipartFile file = MultipartFile.fromBytes('file', bytes);
    return file;
  }
}
