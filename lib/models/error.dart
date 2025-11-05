// TODO use on snackbars
final class ErrorDTO {
  final String code;
  final String message;

  const ErrorDTO({required this.code, required this.message});
}

const errorCodeUnknown = 'UNKNOWN';
const errorCodeNotFound = 'NOT_FOUND';
const errorCodeInvalidForm = 'INVALID_FORM';

final class GameOClockException implements Exception {
  GameOClockException({required this.code, required this.message});

  final String code;
  final String message;
}

final class UnreachableError extends Error {}
