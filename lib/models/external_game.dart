import 'package:equatable/equatable.dart';

class ExternalGame extends Equatable {
  final String externalSource;
  final String externalId;
  final String title;
  final String? edition;
  final String? coverUrl;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> series;

  const ExternalGame({
    required this.externalSource,
    required this.externalId,
    required this.title,
    required this.edition,
    required this.coverUrl,
    required this.releaseDate,
    this.genres = const [],
    this.series = const [],
  });

  @override
  List<Object?> get props => [title]; // TODO
}
