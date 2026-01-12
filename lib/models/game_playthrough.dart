import 'package:equatable/equatable.dart';

class GamePlaythrough extends Equatable {
  final String gameId;
  final String playthroughId;

  const GamePlaythrough({required this.gameId, required this.playthroughId});

  @override
  List<Object?> get props => [gameId, playthroughId];
}
