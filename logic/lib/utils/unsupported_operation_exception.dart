class UnsupportedOperationException implements Exception {
  UnsupportedOperationException(this.message);

  final String message;

  @override
  String toString() {
    return 'UnsupportedOperationException: $message';
  }
}
