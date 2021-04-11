import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

import 'base_api.dart';
import 'cloudinary_response.dart';


class CloudinaryConnection extends BaseApi {
  final String _cloudName;
  final String _apiKey;
  final String _apiSecret;

  CloudinaryConnection(this._apiKey, this._apiSecret, this._cloudName);

  Future<CloudinaryResponse> uploadImage(String imagePath, {String? imageName, String? folder}) async {
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> params = Map<String, dynamic>();

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

    final FormData formData = FormData.fromMap(params);

    final Dio dio = await getApiClient();

    try {

      final Response<Map<String, dynamic>> response = await dio.post<Map<String, dynamic>>(_cloudName + '/image/upload', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data!);

    } catch (error) {

      return CloudinaryResponse.fromError('$error');

    }
  }

  Future<CloudinaryResponse> renameImage({required String imageName, required String newImageName, required String folder}) async {
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> params = Map<String, dynamic>();

    params['api_key'] = _apiKey;
    params['timestamp'] = timeStamp;

    params['from_public_id'] = folder + '/' + imageName;
    params['to_public_id'] = folder + '/' + newImageName + '_' + timeStamp.toString();

    params['signature'] = getSignature(timeStamp, params);

    final FormData formData = FormData.fromMap(params);

    final Dio dio = await getApiClient();

    try{

      final Response<Map<String, dynamic>> response = await dio.post<Map<String, dynamic>>(_cloudName + '/image/rename', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data!);

    } catch(error) {

      return CloudinaryResponse.fromError('$error');

    }

  }

  Future<CloudinaryResponse> deleteImage({required String imageName, required String folder}) async {
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> params = Map<String, dynamic>();

    params['api_key'] = _apiKey;
    params['timestamp'] = timeStamp;

    params['public_id'] = folder + '/' + imageName;

    params['signature'] = getSignature(timeStamp, params);

    final FormData formData = FormData.fromMap(params);

    final Dio dio = await getApiClient();

    try{

      final Response<Map<String, dynamic>> response = await dio.post<Map<String, dynamic>>(_cloudName + '/image/destroy', data: formData);
      return CloudinaryResponse.fromJsonMap(response.data!);

    } catch(error) {

      return CloudinaryResponse.fromError('$error');

    }
  }

  String getSignature(int timestamp, Map<String, dynamic> paramsMap) {

    final Map<String, dynamic> cleanParamsMap = Map<String, dynamic>.from( paramsMap );
    cleanParamsMap.remove('file');
    cleanParamsMap.remove('resource_type');
    cleanParamsMap.remove('api_key');
    cleanParamsMap['timestamp'] = timestamp;

    final List<String> sortedParams = cleanParamsMap.keys.toList(growable: false);
    sortedParams.sort();

    final StringBuffer signBuffer = StringBuffer();
    for(int i = 0; i < sortedParams.length; i++) {
      final String param = sortedParams[i];
      final String value = cleanParamsMap[param].toString();

      signBuffer.write(param + '=' + value);

      if(i < sortedParams.length-1) {
        signBuffer.write('&');
      }
    }
    signBuffer.write(_apiSecret);

    final List<int> bytes = utf8.encode(signBuffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();

  }

  String getImageNameFromPath(String imagePath) {

    return imagePath.split('/').last.split('.').first;

  }

}