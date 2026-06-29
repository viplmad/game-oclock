import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'nav_destination.dart';

final idField = OptionTextField(
  value: 'id',
  labelBuilder: (final context) => context.localize().idLabel,
);

final titleField = OptionTextField(
  value: 'title',
  labelBuilder: (final context) => context.localize().titleLabel,
);

final editionField = OptionTextField(
  value: 'edition',
  labelBuilder: (final context) => context.localize().editionLabel,
);

final releaseDateField = OptionTextField(
  value: 'release_date',
  labelBuilder: (final context) => context.localize().releaseDateLabel,
);

final statusField = OptionTextField(
  value: 'status',
  labelBuilder: (final context) => context.localize().statusLabel,
);

final addedDatetimeField = OptionTextField(
  value: 'added_datetime',
  labelBuilder: (final context) => context.localize().addedDatetimeLabel,
);

final updatedDatetimeField = OptionTextField(
  value: 'updated_datetime',
  labelBuilder: (final context) => context.localize().updatedDatetimeLabel,
);

final gameStatusNextUp = OptionTextField(
  value: MediaStatus.planning.toJson(),
  labelBuilder: (final context) => context.localize().nextUpLabel,
  color: CommonColors.lowPriority,
);

final gameStatusPlaying = OptionTextField(
  value: MediaStatus.inProgress.toJson(),
  labelBuilder: (final context) => context.localize().playingLabel,
  color: CommonColors.playing,
);

final gameStatusCompleted = OptionTextField(
  value: MediaStatus.completed.toJson(),
  labelBuilder: (final context) => context.localize().completedLabel,
  color: CommonColors.completed,
);

final gameStatusDropped = OptionTextField(
  value: MediaStatus.dropped.toJson(),
  labelBuilder: (final context) => context.localize().droppedLabel,
  color: CommonColors.dropped,
);

final List<OptionTextField<String>> gameFieldOptions = List.unmodifiable(
  <OptionTextField<String>>[idField, titleField, editionField, statusField],
);

final List<OptionTextField<String>> gameStatusOptions = List.unmodifiable(
  <OptionTextField<String>>[
    gameStatusNextUp,
    gameStatusPlaying,
    gameStatusCompleted,
    gameStatusDropped,
  ],
);

final List<OptionTextField<String>> gameSessionFinishedOptions =
    List.unmodifiable(<OptionTextField<String>>[
      gameStatusCompleted,
      gameStatusDropped,
    ]);
