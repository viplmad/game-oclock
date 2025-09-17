import 'package:equatable/equatable.dart';

class GameTag extends Equatable {
  final String gameId;
  final String tagId;

  const GameTag({required this.gameId, required this.tagId});

  @override
  List<Object?> get props => [gameId, tagId];
}
