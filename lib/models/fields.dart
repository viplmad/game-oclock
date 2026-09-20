import 'package:game_oclock/utils/localisation_extension.dart';

import 'nav_destination.dart';

final idField = OptionDynamicField(
  value: 'id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().idLabel,
);

final nameField = OptionDynamicField(
  value: 'id',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().idLabel,
);

final imageField = OptionDynamicField(
  value: 'image_url',
  type: FieldType.text,
  labelBuilder: (final context) => context.localize().imageLabel,
);

final addedDatetimeField = OptionDynamicField(
  value: 'added_datetime',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().addedDatetimeLabel,
);

final updatedDatetimeField = OptionDynamicField(
  value: 'updated_datetime',
  type: FieldType.datetime,
  labelBuilder: (final context) => context.localize().updatedDatetimeLabel,
);
