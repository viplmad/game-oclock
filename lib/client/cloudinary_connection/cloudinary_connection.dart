import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'base_api.dart';

import 'cloudinary_response.dart';

class CloudinaryConnection extends BaseApi {
  String _cloudName;
  String _apiKey;
  String _apiSecret;

  CloudinaryConnection(String apiKey, String apiSecret, String cloudName) : assert(apiSecret != null && apiKey != null) {
    this._apiKey = apiKey;
    this._apiSecret = apiSecret;
    this._cloudName = cloudName;
  }

  Future<CloudinaryResponse> uploadImage(String imagePath, {String imageFilename, String folder}) async {
    int timeStamp = new DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();

    params["api_key"] = _apiKey;
    params["timestamp"] = timeStamp;

    String publicId = getImageNameFromPath(imagePath);
    if (imageFilename != null) {
      publicId = imageFilename + '-' + timeStamp.toString();
    } else {
      imageFilename = publicId;
    }
    params["public_id"] = publicId;

    if (folder != null) {
      params["folder"] = folder;
    }

    params["file"] = await MultipartFile.fromFile(imagePath, filename: imageFilename);

    params["signature"] = getSignatureNEW(timeStamp, params);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();

    try {

      Response response = await dio.post(_cloudName + "/image/upload", data: formData);
      return CloudinaryResponse.fromJsonMap(response.data);

    } catch (error, stackTrace) {

      print("Exception occurred: $error stackTrace: $stackTrace");
      return CloudinaryResponse.fromError("$error");

    }
  }

  Future<CloudinaryResponse> renameImage({String imageFilename, String newImageFilename, String folder}) async {
    int timeStamp = new DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();

    params["api_key"] = _apiKey;
    params["timestamp"] = timeStamp;

    params["from_public_id"] = folder + "/" + imageFilename;
    params["to_public_id"] = folder + "/" + newImageFilename;

    params["signature"] = getSignatureNEW(timeStamp, params);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();

    try{

      Response response = await dio.post(_cloudName + "/image/rename", data: formData);
      return CloudinaryResponse.fromJsonMap(response.data);

    } catch(error, stackTrace) {

      print("Exception occurred: $error stackTrace: $stackTrace");
      return CloudinaryResponse.fromError("$error");

    }

  }

  String getSignatureNEW(int timestamp, Map<String, dynamic> paramsMap) {

    Map<String, dynamic> cleanParamsMap = Map.from( paramsMap );
    cleanParamsMap.remove("file");
    cleanParamsMap.remove("resource_type");
    cleanParamsMap.remove("api_key");
    cleanParamsMap["timestamp"] = timestamp;

    List<String> sortedParams = cleanParamsMap.keys.toList();
    sortedParams.sort();

    StringBuffer signBuffer = new StringBuffer();
    for(int i = 0; i < sortedParams.length; i++) {
      String param = sortedParams[i];
      String value = cleanParamsMap[param].toString();

      signBuffer.write(param + "=" + value);

      if(i < sortedParams.length-1) {
        signBuffer.write("&");
      }
    }
    signBuffer.write(_apiSecret);

    List<int> bytes = utf8.encode(signBuffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();

  }

  String getImageNameFromPath(String imagePath) {

    return imagePath.split('/').last.split('.').first;

  }

}
