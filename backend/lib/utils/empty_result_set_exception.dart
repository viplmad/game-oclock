class EmptyResultSetException implements Exception {
  EmptyResultSetException(this.message);

  final String message;

  @override
  String toString() {
    return 'EmptyResultSetException: $message';
  }
}