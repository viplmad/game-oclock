import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart'
    show ApiException, ClientApiException, ErrorCode;

class BlocUtils {
  BlocUtils._();

  static void handleError<S>(
    Object e,
    Emitter<S> emit,
    S Function(ErrorCode error, String errorDescription) errorStateBuilder,
  ) {
    ErrorCode error = ErrorCode.unknown;
    if (e is ApiException) {
      error = e.error;
    }
    emit(
      errorStateBuilder(error, e.toString()),
    );
    _logError(error, e);
  }

  static void handleErrorWithManager<S, ME, MS>(
    Object e,
    Emitter<S> emit,
    Bloc<ME, MS> managerBloc,
    S Function() errorStateBuilder,
    ME Function(ErrorCode error, String errorDescription)
        managerErrorEventBuilder,
  ) {
    ErrorCode error = ErrorCode.unknown;
    if (e is ApiException) {
      error = e.error;
    }
    managerBloc.add(managerErrorEventBuilder(error, e.toString()));
    emit(
      errorStateBuilder(),
    );
    _logError(error, e);
  }

  static void _logError(ErrorCode error, Object e) {
    log(
      e.toString(),
      name: error.toString(),
      error: e,
      stackTrace: e is ClientApiException ? e.stackTrace : null,
    );
  }
}
