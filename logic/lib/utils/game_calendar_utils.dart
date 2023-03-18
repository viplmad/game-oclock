import 'package:game_collection_client/api.dart' show GameLogDTO;

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
        .map<DateTime>((GameLogDTO log) => log.datetime.toDate())
        .toSet();
  }

  static DateTime getEndDateTime(GameLogDTO gameLog) {
    return gameLog.datetime.add(gameLog.time);
  }

  static Comparator<GameLogDTO> logComparatorEarlierFirst() {
    return (GameLogDTO one, GameLogDTO other) => one.datetime.compareTo(other.datetime);
  }

  static Comparator<GameWithLogsDTO> logsComparatorMostTimeFirst() {
    return (GameWithLogsDTO one, GameWithLogsDTO other) => (other.totalTime ?? Duration()).compareTo(one.totalTime ?? Duration());
  }
}
