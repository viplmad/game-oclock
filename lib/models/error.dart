final class ErrorDTO {
  final String code;
  final String message;

  const ErrorDTO({required this.code, required this.message});
}

const errorCodeInvalidForm = 'INVALID_FORM';
