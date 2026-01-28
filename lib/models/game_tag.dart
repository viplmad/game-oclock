import 'package:equatable/equatable.dart';

class GameTag extends Equatable {
  final String gameId;
  final String tagId;
  final int? order;

  const GameTag({required this.gameId, required this.tagId, required this.order});

  @override
  List<Object?> get props => [gameId, tagId];
}
