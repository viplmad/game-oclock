import 'dart:async';

import '../api_helper.dart';
import 'authentication.dart';

class ApiKeyAuth implements Authentication {
  ApiKeyAuth(this.location, this.paramName, {this.refresh});

  final String location;
  final String paramName;

  String apiKeyPrefix = '';
  String apiKey = '';
  final FutureOr<void> Function()? refresh;

  @override
  Future<void> applyToParams(
    final List<QueryParam> queryParams,
    final Map<String, String> headerParams,
  ) async {
    final paramValue = apiKeyPrefix.isEmpty ? apiKey : '$apiKeyPrefix $apiKey';

    if (paramValue.isNotEmpty) {
      if (location == 'query') {
        queryParams.add(QueryParam(paramName, paramValue));
      } else if (location == 'header') {
        headerParams[paramName] = paramValue;
      } else if (location == 'cookie') {
        headerParams.update(
          'Cookie',
          (final existingCookie) => '$existingCookie; $paramName=$paramValue',
          ifAbsent: () => '$paramName=$paramValue',
        );
      }
    }
  }

  @override
  FutureOr<void> onRefresh() async {
    if (refresh != null) {
      await refresh!();
    }
  }
}
