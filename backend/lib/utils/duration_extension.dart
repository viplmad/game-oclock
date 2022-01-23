extension DurationExtension on Duration {
  bool isZero() {
    return this == const Duration();
  }

  int extractNormalisedMinutes() {
    return inMinutes - (inHours * 60);
  }
}