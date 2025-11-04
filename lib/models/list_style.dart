enum ListStyle { tile, grid }

ListStyle? parseListStyle(final String value) {
  try {
    return ListStyle.values.firstWhere(
      (final element) => element.name == value,
    );
  } on StateError {
    return null;
  }
}
