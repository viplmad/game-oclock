import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const Location({required this.id, required this.name, required this.iconUrl});

  @override
  List<Object?> get props => [id];
}

class LocationWithDate extends Location {
  final DateTime date;

  const LocationWithDate({
    required super.id,
    required super.name,
    required super.iconUrl,
    required this.date,
  });
}
