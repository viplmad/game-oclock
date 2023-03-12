import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';

class HttpStatus {
  const HttpStatus._();

  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
}

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
