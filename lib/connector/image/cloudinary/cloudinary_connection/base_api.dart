import 'package:dio/dio.dart';

const String API_BASE_URL = 'https://api.cloudinary.com/v1_1/';

class BaseApi {
  final Dio _dio = Dio();

  BaseApi();

  Future<Dio> getApiClient({InterceptorsWrapper? interceptor}) async {
    _dio.options.baseUrl = API_BASE_URL;
    _dio.interceptors.clear();
    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }
    return _dio;
  }

  Future<Response<T>> httpGet<T>(String url, {Map<String, dynamic>? params}) async {
    final Dio dio = await getApiClient();
    if (params != null) {
      return await dio.get(url, queryParameters: params);
    } else {
      return await dio.get(url);
    }
  }

  Future<Response<T>> httpPost<T>(String url, Map<String, dynamic>? params) async {
    final Dio dio = await getApiClient();
    if (params != null) {
      return await dio.post(url, data: params);
    } else {
      return await dio.post(url);
    }
  }
}