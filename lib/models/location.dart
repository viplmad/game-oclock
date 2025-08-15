import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;

  const Location({required this.id, required this.name});

  @override
  List<Object?> get props => [id];
}

class GameAvailable extends Location {
  final DateTime date;

  const GameAvailable({
    required super.id,
    required super.name,
    required this.date,
  });
}
