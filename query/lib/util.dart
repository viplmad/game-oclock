/// Helper utilities.

class Util {
  Util._();

  static String joinNonEmpty(String separator, Iterable<String> values) {
    final StringBuffer sb = StringBuffer();
    for (final String value in values) {
      if (value.isNotEmpty) {
        if (sb.length > 0) {
          sb.write(separator);
        }
        sb.write(value);
      }
    }
    return sb.toString();
  }
}
