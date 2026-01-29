import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Location({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id];
}

class LocationWithDate extends Location {
  final DateTime date;

  const LocationWithDate({
    required super.id,
    required super.name,
    required super.imageUrl,
    required this.date,
  });
}
