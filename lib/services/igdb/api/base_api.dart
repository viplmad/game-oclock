import 'dart:io';

import 'package:http/http.dart';

import '../api_client.dart';
import '../api_exception.dart';

abstract class BaseApi {
  BaseApi(this.apiClient);

  final ApiClient apiClient;

  Future<void> checkResponse(Response response) async {
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isEmpty || response.statusCode == HttpStatus.noContent) {
      throw ResponseMismatchApiException(
        'Cannot decode 204 response with empty string',
      );
    }
  }
}
