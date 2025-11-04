import 'dart:async';

import '../api_helper.dart';
import 'authentication.dart';

typedef HttpBearerAuthProvider = String Function();

class HttpBearerAuth implements Authentication {
  HttpBearerAuth({this.refresh});

  dynamic _accessToken;
  final FutureOr<void> Function()? refresh;

  dynamic get accessToken => _accessToken;

  set accessToken(final dynamic accessToken) {
    if (accessToken is! String && accessToken is! HttpBearerAuthProvider) {
      throw ArgumentError(
        'accessToken value must be either a String or a String Function().',
      );
    }
    _accessToken = accessToken;
  }

  @override
  Future<void> applyToParams(
    final List<QueryParam> queryParams,
    final Map<String, String> headerParams,
  ) async {
    if (_accessToken == null) {
      return;
    }

    String accessToken;

    if (_accessToken is String) {
      accessToken = _accessToken;
    } else if (_accessToken is HttpBearerAuthProvider) {
      accessToken = _accessToken!();
    } else {
      return;
    }

    if (accessToken.isNotEmpty) {
      headerParams['Authorization'] = 'Bearer $accessToken';
    }
  }

  @override
  FutureOr<void> onRefresh() async {
    if (refresh != null) {
      await refresh!();
    }
  }
}
