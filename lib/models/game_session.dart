import 'package:equatable/equatable.dart';

class GameSession extends Equatable implements Comparable<GameSession> {
  final String gameId;
  final DateTime start;
  final DateTime end;
  final String deviceId;
  final String playthroughId;
  final bool started;
  final String finished;

  const GameSession({
    required this.gameId,
    required this.start,
    required this.end,
    required this.deviceId,
    required this.playthroughId,
    required this.started,
    required this.finished,
  });

  @override
  List<Object?> get props => [gameId, start, end];

  @override
  int compareTo(final GameSession other) {
    return start.compareTo(other.start);
  }
}
