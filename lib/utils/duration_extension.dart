extension DurationExtension on Duration {
  bool isZero() {
    return this == Duration.zero;
  }

  int extractNormalisedMinutes() {
    return inMinutes - (inHours * 60);
  }
}
