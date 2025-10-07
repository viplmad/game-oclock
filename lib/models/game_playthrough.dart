import 'package:equatable/equatable.dart';

class GamePlaythrough extends Equatable {
  final String id;
  final String gameId;
  final String name;

  const GamePlaythrough({
    required this.id,
    required this.gameId,
    required this.name,
  });

  @override
  List<Object?> get props => [gameId, name];
}
