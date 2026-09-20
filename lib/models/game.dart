import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'fields.dart';
import 'nav_destination.dart';

final mediaKindField = OptionDynamicField(
  value: 'kind',
  type: FieldType.options,
  labelBuilder: (final context) => context.localize().kindLabel,
);

final titleField = OptionDynamicField(
  value: 'title',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().titleLabel,
);

final editionField = OptionDynamicField(
  value: 'edition',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().editionLabel,
);

final releaseDateField = OptionDynamicField(
  value: 'release_date',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().releaseDateLabel,
);

final parentIdField = OptionDynamicField(
  value: 'parent_id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().parentIdLabel,
);

final parentOrderField = OptionDynamicField(
  value: 'parent_order',
  type: FieldType.integer,
  labelBuilder: (final context) => context.localize().parentOrderLabel,
);

final statusField = OptionDynamicField(
  value: 'status',
  type: FieldType.options,
  labelBuilder: (final context) => context.localize().statusLabel,
);

final ratingField = OptionDynamicField(
  value: 'rating',
  type: FieldType.integer,
  labelBuilder: (final context) => context.localize().ratingLabel,
);

final notesField = OptionDynamicField(
  value: 'notes',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().notesLabel,
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

final List<OptionTextField<String>> gameFieldOptions =
    List.unmodifiable(<OptionTextField<String>>[
      idField,
      mediaKindField,
      titleField,
      editionField,
      releaseDateField,
      imageField,
      parentIdField,
      parentOrderField,
      statusField,
      ratingField,
      notesField,
      addedDatetimeField,
      updatedDatetimeField,
    ]);

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
