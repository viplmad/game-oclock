import 'package:equatable/equatable.dart';

class GameSession extends Equatable {
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
}
