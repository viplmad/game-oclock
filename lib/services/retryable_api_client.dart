import 'dart:async';
import 'dart:io';

import 'package:game_oclock_client/api.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

class RetryableApiClient extends ApiClient {
  RetryableApiClient() : apiClient = null;

  ApiClient? apiClient;

  /// Callback to refresh authentication
  Future<OAuth> Function(ApiClient, OAuth)? onRefresh;

  void update({
    required final String basePath,
    required final OAuth authentication,
    required final Future<OAuth> Function(ApiClient, OAuth)? onRefresh,
  }) {
    apiClient = ApiClient(basePath: basePath, authentication: authentication);
    this.onRefresh = onRefresh;
  }

  // We don't use a Map<String, String> for queryParams.
  // If collectionFormat is 'multi', a key might appear multiple times.
  @override
  Future<Response> invokeAPI(
    String path,
    String method,
    List<QueryParam> queryParams,
    Object? body,
    Map<String, String> headerParams,
    Map<String, String> formParams,
    String? contentType,
  ) async {
    if (apiClient == null) {
      throw Error();
    }

    final retry = const RetryOptions(maxAttempts: 3);
    return await retry.retry(
      () async {
        final Response response = await apiClient!
            .invokeAPI(
              path,
              method,
              queryParams,
              body,
              headerParams,
              formParams,
              contentType,
            )
            .timeout(const Duration(seconds: 10));

        // Handle 401 without body from regular calls
        if (response.statusCode == HttpStatus.unauthorized &&
            response.body.isEmpty) {
          throw UnauthorizedApiException(
            HttpStatus.unauthorized,
            'Access token not valid',
          );
        }
        if (response.statusCode >= HttpStatus.badRequest) {
          final errorMessage =
              await apiClient!.deserializeAsync(
                    await decodeBodyBytes(response),
                    'ErrorMessage',
                  )
                  as ErrorMessage;
          throw ApiException.fromServer(
            response.statusCode,
            errorMessage.error,
            errorMessage.errorDescription,
          );
        }

        return response;
      },
      retryIf: (final error) =>
          // If it's unauthorized and this client has authentication (retrying to refresh)
          (error is UnauthorizedApiException &&
              apiClient!.authentication != null) ||
          // If it's a client error (retrying will not change response)
          (error is ClientApiException),
      onRetry: (final error) async {
        if (error is UnauthorizedApiException) {
          if (onRefresh != null) {
            final newAuth = await onRefresh!(
              apiClient!,
              authentication as OAuth,
            );
            apiClient = ApiClient(
              basePath: apiClient!.basePath,
              authentication: newAuth,
            );
          }
        }
      },
    );
  }
}
