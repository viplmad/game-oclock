import 'package:game_collection_client/api.dart'
    show GameLogDTO, GameWithLogsDTO;

import 'datetime_extension.dart';

class GameCalendarUtils {
  GameCalendarUtils._();

  static Duration getTotalTime(List<GameLogDTO> gameLogs) {
    return gameLogs.fold<Duration>(
      const Duration(),
      (Duration previousDuration, GameLogDTO log) =>
          previousDuration + log.time,
    );
  }

  static Set<DateTime> getUniqueLogDates(List<GameLogDTO> gameLogs) {
    return gameLogs
        .map<DateTime>((GameLogDTO log) => log.startDatetime.toDate())
        .toSet();
  }

  static Comparator<GameLogDTO> logComparatorEarlierFirst() {
    return (GameLogDTO one, GameLogDTO other) =>
        one.startDatetime.compareTo(other.startDatetime);
  }

  static Comparator<GameWithLogsDTO> logsComparatorMostTimeFirst() {
    return (GameWithLogsDTO one, GameWithLogsDTO other) =>
        (other.totalTime ?? const Duration())
            .compareTo(one.totalTime ?? const Duration());
  }
}
