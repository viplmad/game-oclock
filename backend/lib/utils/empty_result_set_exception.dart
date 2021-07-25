class EmptyResultSetException implements Exception {
  EmptyResultSetException(this.cause);

  final String cause;
}