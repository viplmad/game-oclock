class StatisticsUtils {
  static List<int> createIntervals(
    int chunk,
    int minReleaseYear,
    int maxReleaseYear,
  ) {
    int minYear;
    final int minRemainder = minReleaseYear % chunk;
    if (minRemainder == 0) {
      minYear = minReleaseYear;
    } else {
      minYear = minReleaseYear - minRemainder;
    }

    int maxYear;
    final int maxRemainder = maxReleaseYear % chunk;
    if (maxRemainder == 0) {
      maxYear = maxReleaseYear;
    } else {
      maxYear = maxReleaseYear + (chunk - maxRemainder);
    }

    final List<int> intervals = <int>[];
    for (int year = minYear; year <= maxYear; year += chunk) {
      intervals.add(year);
    }
    return intervals;
  }

  static List<int> intervalCount(List<int> intervals, Map<int, int> data) {
    final List<int> values = List<int>.filled(intervals.length - 1, 0);
    int index = 0;

    for (int intervalIndex = 0;
        intervalIndex < intervals.length - 1;
        intervalIndex++) {
      final int min = intervals.elementAt(intervalIndex);
      final int max = intervals.elementAt(intervalIndex + 1);

      final int intervalCount = data.entries
          .where(
            (MapEntry<int, int> entry) => min < entry.key && entry.key <= max,
          )
          .map((MapEntry<int, int> entry) => entry.value)
          .reduce((int sum, int value) => sum + value);

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCountWithInitial(List<int> intervals, Map<int, int> data) {
    final List<int> values = List<int>.filled(intervals.length, 0);
    int index = 0;

    final int initialElement = intervals.first;
    final int initialIntervalCount = data.entries
        .where((MapEntry<int, int> entry) => entry.key <= initialElement)
        .map((MapEntry<int, int> entry) => entry.value)
        .reduce((int sum, int value) => sum + value);
    values[index++] = initialIntervalCount;

    for (int intervalIndex = 0;
        intervalIndex < intervals.length - 1;
        intervalIndex++) {
      final int min = intervals.elementAt(intervalIndex);
      final int max = intervals.elementAt(intervalIndex + 1);

      final int intervalCount = data.entries
          .where(
            (MapEntry<int, int> entry) => min < entry.key && entry.key <= max,
          )
          .map((MapEntry<int, int> entry) => entry.value)
          .reduce((int sum, int value) => sum + value);

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCountWithLast(List<int> intervals, Map<int, int> data) {
    final List<int> values = List<int>.filled(intervals.length, 0);
    int index = 0;

    for (int intervalIndex = 0;
        intervalIndex < intervals.length - 1;
        intervalIndex++) {
      final int min = intervals.elementAt(intervalIndex);
      final int max = intervals.elementAt(intervalIndex + 1);

      final int intervalCount = data.entries
          .where(
            (MapEntry<int, int> entry) => min < entry.key && entry.key <= max,
          )
          .map((MapEntry<int, int> entry) => entry.value)
          .reduce((int sum, int value) => sum + value);

      values[index++] = intervalCount;
    }

    final int lastElement = intervals.last;
    final int lastIntervalCount = data.entries
        .where((MapEntry<int, int> entry) => lastElement < entry.key)
        .map((MapEntry<int, int> entry) => entry.value)
        .reduce((int sum, int value) => sum + value);
    values[index] = lastIntervalCount;

    return values;
  }

  List<int> intervalCountWithInitialAndLast(
    List<int> intervals,
    Map<int, int> data,
  ) {
    final List<int> values = List<int>.filled(intervals.length + 1, 0);
    int index = 0;

    final int initialElement = intervals.first;
    final int initialIntervalCount = data.entries
        .where((MapEntry<int, int> entry) => entry.key <= initialElement)
        .map((MapEntry<int, int> entry) => entry.value)
        .reduce((int sum, int value) => sum + value);
    values[index++] = initialIntervalCount;

    for (int intervalIndex = 0;
        intervalIndex < intervals.length - 1;
        intervalIndex++) {
      final int min = intervals.elementAt(intervalIndex);
      final int max = intervals.elementAt(intervalIndex + 1);

      final int intervalCount = data.entries
          .where(
            (MapEntry<int, int> entry) => min < entry.key && entry.key <= max,
          )
          .map((MapEntry<int, int> entry) => entry.value)
          .reduce((int sum, int value) => sum + value);

      values[index++] = intervalCount;
    }

    final int lastElement = intervals.last;
    final int lastIntervalCount = data.entries
        .where((MapEntry<int, int> entry) => lastElement < entry.key)
        .map((MapEntry<int, int> entry) => entry.value)
        .reduce((int sum, int value) => sum + value);
    values[index] = lastIntervalCount;

    return values;
  }
}
