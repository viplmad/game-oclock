import 'dart:async';

import '../api_helper.dart';

abstract class Authentication {
  /// Apply authentication settings to header and query params.
  Future<void> applyToParams(
    final List<QueryParam> queryParams,
    final Map<String, String> headerParams,
  );

  /// Callback to refresh authentication
  FutureOr<void> onRefresh();
}
