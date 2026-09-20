import 'package:game_oclock/utils/localisation_extension.dart';

import 'fields.dart';
import 'nav_destination.dart';

final timeField = OptionDynamicField(
  value: 'time',
  type: FieldType.duration,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final mediaIdField = OptionDynamicField(
  value: 'media_id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final startDateField = OptionDynamicField(
  value: 'start_date',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final endDateField = OptionDynamicField(
  value: 'end_date',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final deviceIdField = OptionDynamicField(
  value: 'device_id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final groupIdField = OptionDynamicField(
  value: 'group_id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final startedField = OptionDynamicField(
  value: 'started',
  type: FieldType.bool,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final finishedStatusField = OptionDynamicField(
  value: 'finished_status',
  type: FieldType.options,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final mediaReleaseDateField = OptionDynamicField(
  value: 'media_release_date',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final mediaRatingField = OptionDynamicField(
  value: 'media_rating',
  type: FieldType.integer,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final mediaGenreField = OptionDynamicField(
  value: 'media_genre',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().roleLabel,
);

final List<OptionTextField<String>> sessionFieldOptions =
    List.unmodifiable(<OptionTextField<String>>[
      timeField,
      mediaIdField,
      startDateField,
      endDateField,
      deviceIdField,
      groupIdField,
      startedField,
      finishedStatusField,
      addedDatetimeField,
      updatedDatetimeField,
    ]);
