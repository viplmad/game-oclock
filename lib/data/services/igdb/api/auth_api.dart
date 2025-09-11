import 'package:http/http.dart';

import '../api_helper.dart';
import '../models/models.dart';
import 'base_api.dart';

class AuthApi extends BaseApi {
  AuthApi(super.apiClient);

  /// Performs an HTTP 'POST /auth/token' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [GrantType] grantType (required):
  ///
  /// * [String] password:
  ///
  /// * [String] refreshToken:
  ///
  /// * [String] username:
  Future<Response> tokenWithHttpInfo(
    String grantType,
    String clientId,
    String clientSecret,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/token';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    queryParams.addAll(newQueryParams('', 'grant_type', grantType));
    queryParams.addAll(newQueryParams('', 'client_id', clientId));
    queryParams.addAll(newQueryParams('', 'client_secret', clientSecret));

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [GrantType] grantType (required):
  ///
  /// * [String] password:
  ///
  /// * [String] refreshToken:
  ///
  /// * [String] username:
  Future<TokenResponse> token(
    String grantType,
    String clientId,
    String clientSecret,
  ) async {
    final response = await tokenWithHttpInfo(grantType, clientId, clientSecret);
    await checkResponse(response);
    return await apiClient.deserializeAsync(
          await decodeBodyBytes(response),
          'TokenResponse',
        )
        as TokenResponse;
  }
}
