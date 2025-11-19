import 'package:equatable/equatable.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'nav_destination.dart';

final List<OptionTextField<String>> gameFieldOptions =
    List.unmodifiable(<OptionTextField<String>>[
      OptionTextField(
        value: 'id',
        labelBuilder: (final context) => context.localize().idLabel,
      ),
      OptionTextField(
        value: 'title',
        labelBuilder: (final context) => context.localize().titleLabel,
      ),
      OptionTextField(
        value: 'edition',
        labelBuilder: (final context) => context.localize().editionLabel,
      ),
    ]);

final List<OptionTextField<String>> gameStatusOptions =
    List.unmodifiable(<OptionTextField<String>>[
      OptionTextField(
        value: 'wishlist',
        labelBuilder: (final context) => context.localize().wishlistLabel,
        color: CommonColors.wishlistColor,
      ),
      OptionTextField(
        value: 'lowPriorty',
        labelBuilder: (final context) => context.localize().lowPriorityLabel,
        color: CommonColors.lowPriorityColor,
      ),
      OptionTextField(
        value: 'nextUp',
        labelBuilder: (final context) => context.localize().nextUpLabel,
        color: CommonColors.nextUpColor,
      ),
      OptionTextField(
        value: 'playing',
        labelBuilder: (final context) => context.localize().playingLabel,
        color: CommonColors.playingColor,
      ),
      OptionTextField(
        value: 'played',
        labelBuilder: (final context) => context.localize().playedLabel,
        color: CommonColors.playedColor,
      ),
    ]);

final List<OptionTextField<String>> gameSessionFinishedOptions =
    List.unmodifiable(<OptionTextField<String>>[
      OptionTextField(
        value: 'completed',
        labelBuilder: (final context) => context.localize().completedLabel,
        color: CommonColors.completedColor,
      ),
      OptionTextField(
        value: 'retired',
        labelBuilder: (final context) => context.localize().retiredLabel,
        color: CommonColors.retiredColor,
      ),
    ]);

class Game extends Equatable {
  final String id;
  final List<ExternalGameId> externalIds;
  final String title;
  final String edition;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> series;
  final String coverUrl;

  const Game({
    required this.id,
    required this.externalIds,
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
    required super.externalIds,
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

class UserGameWithDate extends UserGame {
  final DateTime date;

  const UserGameWithDate({
    required super.id,
    required super.externalIds,
    required super.title,
    required super.edition,
    required super.releaseDate,
    required super.genres,
    required super.series,
    required super.coverUrl,
    required super.status,
    required super.rating,
    required super.notes,
    required this.date,
  });
}

class ExternalGameId {
  final String source;
  final String id;

  ExternalGameId({required this.source, required this.id});
}
