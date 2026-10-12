import 'package:equatable/equatable.dart';

class GameChild extends Equatable {
  final String parentGameId;
  final String childGameId;
  final int? order;

  const GameChild({
    required this.parentGameId,
    required this.childGameId,
    this.order,
  });

  @override
  List<Object?> get props => [parentGameId, childGameId];
}
