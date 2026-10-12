import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

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

class ReviewStartEnd {
  ReviewStartEnd({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class NewMediaSession extends NewSessionDTO {
  NewMediaSession({
    required this.gameId,
    required super.deviceId,
    required super.endDatetime,
    super.finishedStatus,
    required super.groupId,
    required super.startDatetime,
    required super.started,
  });

  final String gameId;
}

class MediaWithTime {
  MediaWithTime({required this.media, required this.time});

  final MediaDTO media;
  final Duration time;
}
