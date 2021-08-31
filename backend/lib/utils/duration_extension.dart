extension DurationExtension on Duration {
  bool isZero() {
    return this == const Duration();
  }

  int extractNormalisedMinutes() {
    return this.inMinutes - (this.inHours * 60);
  }
}