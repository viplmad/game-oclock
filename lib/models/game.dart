import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

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

final gameStatusLowPriority = OptionTextField(
  value: 'lowPriority',
  labelBuilder: (final context) => context.localize().lowPriorityLabel,
  color: CommonColors.lowPriority,
);

final gameStatusNextUp = OptionTextField(
  value: 'nextUp',
  labelBuilder: (final context) => context.localize().nextUpLabel,
  color: CommonColors.nextUp,
);

final gameStatusPlaying = OptionTextField(
  value: 'playing',
  labelBuilder: (final context) => context.localize().playingLabel,
  color: CommonColors.playing,
);

final gameStatusPlayed = OptionTextField(
  value: 'played',
  labelBuilder: (final context) => context.localize().playedLabel,
  color: CommonColors.played,
);

final List<OptionTextField<String>> gameFieldOptions = List.unmodifiable(
  <OptionTextField<String>>[idField, titleField, editionField, statusField],
);

final List<OptionTextField<String>> gameStatusOptions = List.unmodifiable(
  <OptionTextField<String>>[
    gameStatusLowPriority,
    gameStatusNextUp,
    gameStatusPlaying,
    gameStatusPlayed,
  ],
);

final List<OptionTextField<String>> gameSessionFinishedOptions =
    List.unmodifiable(<OptionTextField<String>>[
      OptionTextField(
        value: 'completed',
        labelBuilder: (final context) => context.localize().completedLabel,
        color: CommonColors.completed,
      ),
      OptionTextField(
        value: 'retired',
        labelBuilder: (final context) => context.localize().retiredLabel,
        color: CommonColors.retired,
      ),
    ]);
