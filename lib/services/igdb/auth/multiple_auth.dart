import 'dart:async';

import '../api_helper.dart';
import 'authentication.dart';

class MultipleAuth implements Authentication {
  MultipleAuth(this.auths, {this.refresh});

  final List<Authentication> auths;

  final FutureOr<void> Function()? refresh;

  @override
  Future<void> applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) async {
    for (final auth in auths) {
      auth.applyToParams(queryParams, headerParams);
    }
  }

  @override
  FutureOr<void> onRefresh() async {
    if (refresh != null) {
      await this.refresh!();
    }
  }
}
