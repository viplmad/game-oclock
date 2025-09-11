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
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
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
          (existingCookie) => '$existingCookie; $paramName=$paramValue',
          ifAbsent: () => '$paramName=$paramValue',
        );
      }
    }
  }

  @override
  FutureOr<void> onRefresh() async {
    if (refresh != null) {
      await this.refresh!();
    }
  }
}
