import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'base_api.dart';

import 'cloudinary_response.dart';

class ImageClient extends BaseApi {
  String _cloudName;
  String _apiKey;
  String _apiSecret;

  ImageClient(String apiKey, String apiSecret, String cloudName) {
    this._apiKey = apiKey;
    this._apiSecret = apiSecret;
    this._cloudName = cloudName;
  }

  Future<CloudinaryResponse> uploadImage(String imagePath,
      {String imageFilename, String folder, bool overwrite}) async {
    int timeStamp = new DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();
    if (_apiSecret == null || _apiKey == null) {
      throw Exception("apiKey and apiSecret must not be null");
    }

    params["api_key"] = _apiKey;

    if (imagePath == null) {
      throw Exception("imagePath must not be null");
    }
    String publicId = imagePath.split('/').last;
    publicId = publicId.split('.')[0];

    if (imageFilename != null) {
      publicId = imageFilename.split('.')[0] + '-' + timeStamp.toString();
    } else {
      imageFilename = publicId;
    }

    if (folder != null) {
      params["folder"] = folder;
    }

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    bool uniqueFilename;
    if(overwrite != null) {
      uniqueFilename = true;
      params["unique_filename"] = "true";
      params["overwrite"] = "false";
      if(overwrite) {
        uniqueFilename = false;
        params["overwrite"] = "true";
        params["unique_filename"] = "false";
      }
    }

    params["file"] =
    await MultipartFile.fromFile(imagePath, filename: imageFilename);
    params["timestamp"] = timeStamp;
    params["signature"] = getSignature(timeStamp, folder: folder, overwrite: overwrite, publicId: publicId, uniqueFilename: uniqueFilename);

    FormData formData = new FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
    await dio.post(_cloudName + "/image/upload", data: formData);
    try {
      return CloudinaryResponse.fromJsonMap(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return CloudinaryResponse.fromError("$error");
    }
  }

  String getSignature(int timeStamp, {String folder, bool overwrite, String publicId, bool uniqueFilename}) {
    var buffer = new StringBuffer();
    if (folder != null) {
      buffer.write("folder=" + folder + "&");
    }
    if(overwrite != null) {
      buffer.write("overwrite=" + overwrite.toString() + "&");
    }
    if (publicId != null) {
      buffer.write("public_id=" + publicId + "&");
    }
    buffer.write("timestamp=" + timeStamp.toString());
    if(uniqueFilename != null) {
      buffer.write("&");
      buffer.write("unique_filename=" + uniqueFilename.toString());
    }
    buffer.write(_apiSecret);

    var bytes = utf8.encode(buffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();
  }
}
