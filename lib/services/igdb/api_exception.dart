enum ErrorCode {
  // Server
  invalidParameter,
  alreadyExists,
  notFound,
  notSupported,
  unauthorized,
  forbidden,
  unknown,

  // Auth
  authInvalidRequest,
  authInvalidGrant,
  authUnsupportedGrantType,

  // Client
  connectionFailed,
  responseMismatch,
  unexpected,
}

abstract class ApiException implements Exception {
  ApiException({required this.error, required this.errorDescription});

  ErrorCode error;
  String errorDescription;

  factory ApiException.fromServer(
    int statusCode,
    String error,
    String errorDescription,
  ) {
    switch (error) {
      case InvalidParameterApiException.code:
        return InvalidParameterApiException(statusCode, errorDescription);
      case AlreadyExistsApiException.code:
        return AlreadyExistsApiException(statusCode, errorDescription);
      case NotFoundApiException.code:
        return NotFoundApiException(statusCode, errorDescription);
      case AuthInvalidRequestTokenException.code:
        return AuthInvalidRequestTokenException(statusCode, errorDescription);
      case AuthInvalidGrantTokenException.code:
        return AuthInvalidGrantTokenException(statusCode, errorDescription);
      case AuthUnsupportedGrantTypeTokenException.code:
        return AuthUnsupportedGrantTypeTokenException(
          statusCode,
          errorDescription,
        );
      case NotSupportedApiException.code:
        return NotSupportedApiException(statusCode, errorDescription);
      case ForbiddenApiException.code:
        return ForbiddenApiException(statusCode, errorDescription);
      case UnknownErrorApiException.code:
        return UnknownErrorApiException(statusCode, errorDescription);
    }
    return UnknownErrorApiException(statusCode, errorDescription);
  }
}

abstract class ClientApiException extends ApiException {
  ClientApiException({
    required super.error,
    required super.errorDescription,
    this.innerException,
    this.stackTrace,
  });

  Exception? innerException;
  StackTrace? stackTrace;

  @override
  String toString() {
    if (innerException != null) {
      return 'ApiException ${error.name}: $errorDescription (Inner exception: $innerException)\n\n$stackTrace';
    }
    return 'ApiException ${error.name}: $errorDescription';
  }
}

class ConnectionFailedApiException extends ClientApiException {
  ConnectionFailedApiException(
    String errorDescription, [
    Exception? innerException,
    StackTrace? stackTrace,
  ]) : super(
         error: ErrorCode.connectionFailed,
         errorDescription: errorDescription,
         innerException: innerException,
         stackTrace: stackTrace,
       );
}

class ResponseMismatchApiException extends ClientApiException {
  ResponseMismatchApiException(
    String errorDescription, [
    Exception? innerException,
    StackTrace? stackTrace,
  ]) : super(
         error: ErrorCode.responseMismatch,
         errorDescription: errorDescription,
         innerException: innerException,
         stackTrace: stackTrace,
       );
}

class UnexpectedApiException extends ClientApiException {
  UnexpectedApiException(
    String errorDescription, [
    Exception? innerException,
    StackTrace? stackTrace,
  ]) : super(
         error: ErrorCode.responseMismatch,
         errorDescription: errorDescription,
         innerException: innerException,
         stackTrace: stackTrace,
       );
}

abstract class ServerApiException extends ApiException {
  ServerApiException({
    required this.statusCode,
    required super.error,
    required super.errorDescription,
  });

  int statusCode = 0;

  @override
  String toString() {
    return 'ApiException [$statusCode] ${error.name}: $errorDescription';
  }
}

class InvalidParameterApiException extends ServerApiException {
  static const String code = 'invalid_parameter';

  InvalidParameterApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.invalidParameter,
        errorDescription: errorDescription,
      );
}

class AlreadyExistsApiException extends ServerApiException {
  static const String code = 'already_exists';

  AlreadyExistsApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.alreadyExists,
        errorDescription: errorDescription,
      );
}

class NotFoundApiException extends ServerApiException {
  static const String code = 'not_found';

  NotFoundApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.notFound,
        errorDescription: errorDescription,
      );
}

class NotSupportedApiException extends ServerApiException {
  static const String code = 'not_supported';

  NotSupportedApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.notSupported,
        errorDescription: errorDescription,
      );
}

class UnauthorizedApiException extends ServerApiException {
  static const String code = 'unauthorized';

  UnauthorizedApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.unauthorized,
        errorDescription: errorDescription,
      );
}

class ForbiddenApiException extends ServerApiException {
  static const String code = 'forbidden';

  ForbiddenApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.forbidden,
        errorDescription: errorDescription,
      );
}

class UnknownErrorApiException extends ServerApiException {
  static const String code = 'unknown_error';

  UnknownErrorApiException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.unknown,
        errorDescription: errorDescription,
      );
}

class AuthInvalidRequestTokenException extends ServerApiException {
  static const String code = 'invalid_request';

  AuthInvalidRequestTokenException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.authInvalidRequest,
        errorDescription: errorDescription,
      );
}

class AuthInvalidGrantTokenException extends ServerApiException {
  static const String code = 'invalid_grant';

  AuthInvalidGrantTokenException(int statusCode, String errorDescription)
    : super(
        statusCode: statusCode,
        error: ErrorCode.authInvalidGrant,
        errorDescription: errorDescription,
      );
}

class AuthUnsupportedGrantTypeTokenException extends ServerApiException {
  static const String code = 'unsupported_grant_type';

  AuthUnsupportedGrantTypeTokenException(
    int statusCode,
    String errorDescription,
  ) : super(
        statusCode: statusCode,
        error: ErrorCode.authUnsupportedGrantType,
        errorDescription: errorDescription,
      );
}
