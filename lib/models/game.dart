import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'nav_destination.dart';

List<DropdownField> gameFieldOptions = List.unmodifiable(<DropdownField>[
  DropdownField(
    value: 'id',
    labelBuilder: (final context) => context.localize().idLabel,
  ),
  DropdownField(
    value: 'title',
    labelBuilder: (final context) => context.localize().titleLabel,
  ),
  DropdownField(
    value: 'edition',
    labelBuilder: (final context) => context.localize().editionLabel,
  ),
]);

List<DropdownField> gameStatusOptions = List.unmodifiable(<DropdownField>[
  DropdownField(
    value: 'wishlist',
    labelBuilder: (final context) => context.localize().wishlistLabel,
    color: Colors.yellow,
  ),
  DropdownField(
    value: 'lowPriorty',
    labelBuilder: (final context) => context.localize().lowPriorityLabel,
    color: Colors.grey,
  ),
  DropdownField(
    value: 'nextUp',
    labelBuilder: (final context) => context.localize().nextUpLabel,
    color: Colors.red,
  ),
  DropdownField(
    value: 'playing',
    labelBuilder: (final context) => context.localize().playingLabel,
    color: Colors.blue,
  ),
  DropdownField(
    value: 'played',
    labelBuilder: (final context) => context.localize().playedLabel,
    color: Colors.green,
  ),
]);

List<DropdownField> gameSessionFinishedOptions =
    List.unmodifiable(<DropdownField>[
      DropdownField(
        value: 'completed',
        labelBuilder: (final context) => context.localize().completedLabel,
        color: Colors.green,
      ),
      DropdownField(
        value: 'retired',
        labelBuilder: (final context) => context.localize().retiredLabel,
        color: Colors.grey,
      ),
    ]);

class Game extends Equatable {
  final String id;
  final String externalId;
  final String title;
  final String edition;
  final DateTime? releaseDate;
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
