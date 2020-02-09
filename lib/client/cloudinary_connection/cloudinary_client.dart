import 'cloudinary_response.dart';
import 'image_client.dart';

class CloudinaryClient {
  String _apiKey;
  String _apiSecret;
  String _cloudName;
  ImageClient _client;

  CloudinaryClient(String apiKey, String apiSecret, String cloudName) {
    this._apiKey = apiKey;
    this._apiSecret = apiSecret;
    this._cloudName = cloudName;
    _client = ImageClient(_apiKey, _apiSecret, _cloudName);
  }

  Future<CloudinaryResponse> uploadImage(String imagePath,
      {String filename, String folder, bool overwrite = false}) async {
    return _client.uploadImage(imagePath,
        imageFilename: filename, folder: folder, overwrite: overwrite);
  }

  Future<List<CloudinaryResponse>> uploadImages(List<String> imagePaths,
      {String filename, String folder}) async {
    List<CloudinaryResponse> responses = List();

    for (var path in imagePaths) {
      CloudinaryResponse resp = await _client.uploadImage(path,
          imageFilename: filename, folder: folder);
      responses.add(resp);
    }
    return responses;
  }

  Future<List<String>> uploadImagesStringResp(List<String> imagePaths,
      {String filename, String folder}) async {
    List<String> responses = List();

    for (var path in imagePaths) {
      CloudinaryResponse resp = await _client.uploadImage(path,
          imageFilename: filename, folder: folder);
      responses.add(resp.url);
    }
    return responses;
  }
}