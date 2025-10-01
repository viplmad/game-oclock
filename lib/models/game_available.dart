import 'package:equatable/equatable.dart';

class GameAvailable extends Equatable {
  final String gameId;
  final String locationId;
  final DateTime date;

  const GameAvailable({
    required this.gameId,
    required this.locationId,
    required this.date,
  });

  @override
  List<Object?> get props => [gameId, locationId];
}
