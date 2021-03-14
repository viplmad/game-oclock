import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

import 'base_api.dart';
import 'cloudinary_response.dart';


class CloudinaryConnection extends BaseApi {
  String _cloudName;
  String _apiKey;
  String _apiSecret;

  CloudinaryConnection(this._apiKey, this._apiSecret, this._cloudName);

  Future<CloudinaryResponse> uploadImage(String imagePath, {String? imageName, String? folder}) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();

    params['api_key'] = _apiKey;
    params['timestamp'] = timeStamp;

    String publicId = getImageNameFromPath(imagePath);
    if (imageName != null) {
      publicId = imageName + '_' + timeStamp.toString();
    }
    params['public_id'] = publicId;

    if (folder != null) {
      params['folder'] = folder;
    }

    params['file'] = await MultipartFile.fromFile(imagePath, filename: imageName);

    params['signature'] = getSignature(timeStamp, params);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();

    try {

      Response response = await dio.post(_cloudName + '/image/upload', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data);

    } catch (error, stackTrace) {

      print('Exception occurred: $error stackTrace: $stackTrace');
      return CloudinaryResponse.fromError('$error');

    }
  }

  Future<CloudinaryResponse> renameImage({required String imageName, required String newImageName, required String folder}) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();

    params['api_key'] = _apiKey;
    params['timestamp'] = timeStamp;

    params['from_public_id'] = folder + '/' + imageName;
    params['to_public_id'] = folder + '/' + newImageName + '_' + timeStamp.toString();

    params['signature'] = getSignature(timeStamp, params);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();

    try{

      Response response = await dio.post(_cloudName + '/image/rename', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data);

    } catch(error, stackTrace) {

      print('Exception occurred: $error stackTrace: $stackTrace');
      return CloudinaryResponse.fromError('$error');

    }

  }

  Future<CloudinaryResponse> deleteImage({required String imageName, required String folder}) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = new Map();

    params['api_key'] = _apiKey;
    params['timestamp'] = timeStamp;

    params['public_id'] = folder + '/' + imageName;

    params['signature'] = getSignature(timeStamp, params);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();

    try{

      Response response = await dio.post(_cloudName + '/image/destroy', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data);

    } catch(error, stackTrace) {

      print('Exception occurred: $error stackTrace: $stackTrace');
      return CloudinaryResponse.fromError('$error');

    }
  }

  String getSignature(int timestamp, Map<String, dynamic> paramsMap) {

    Map<String, dynamic> cleanParamsMap = Map.from( paramsMap );
    cleanParamsMap.remove('file');
    cleanParamsMap.remove('resource_type');
    cleanParamsMap.remove('api_key');
    cleanParamsMap['timestamp'] = timestamp;

    List<String> sortedParams = cleanParamsMap.keys.toList(growable: false);
    sortedParams.sort();

    StringBuffer signBuffer = new StringBuffer();
    for(int i = 0; i < sortedParams.length; i++) {
      String param = sortedParams[i];
      String value = cleanParamsMap[param].toString();

      signBuffer.write(param + '=' + value);

      if(i < sortedParams.length-1) {
        signBuffer.write('&');
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