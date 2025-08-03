import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final String id;
  final String externalId;
  final String title;
  final String edition;
  final DateTime releaseDate;
  final List<String> genres;
  final List<String> series;
  final String coverUrl;

  const Game({
    required this.id,
    required this.externalId,
    required this.title,
    required this.edition,
    required this.releaseDate,
    required this.genres,
    required this.series,
    required this.coverUrl,
  });

  @override
  List<Object?> get props => [id];
}

class UserGame extends Game {
  final String status;
  final int rating;
  final String notes;

  const UserGame({
    required super.id,
    required super.externalId,
    required super.title,
    required super.edition,
    required super.releaseDate,
    required super.genres,
    required super.series,
    required super.coverUrl,
    required this.status,
    required this.rating,
    required this.notes,
  });
}
