import 'package:equatable/equatable.dart';

import 'game.dart';

class ExternalGame extends Equatable {
  final ExternalGameId externalId;
  final String title;
  final String? edition;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> series;
  final String? imageUrl;
  final String? parentId;
  final int? parentOrder;
  final UserGameInfo? userInfo;

  const ExternalGame({
    required this.externalId,
    required this.title,
    required this.edition,
    required this.releaseDate,
    this.genres = const [],
    this.series = const [],
    required this.imageUrl,
    this.parentId,
    this.parentOrder,
    this.userInfo,
  });

  @override
  List<Object?> get props => [title]; // TODO
}

class UserGameInfo {
  final String id;
  final String status;
  final int rating;
  final String notes;

  UserGameInfo({
    required this.id,
    required this.status,
    required this.rating,
    required this.notes,
  });
}
