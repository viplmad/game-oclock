import 'package:game_oclock_client/api.dart';

import 'fields.dart';
import 'nav_destination.dart';

final List<OptionTextField<String>> deviceFieldOptions = List.unmodifiable(
  <OptionTextField<String>>[
    idField,
    nameField,
    imageField,
    addedDatetimeField,
    updatedDatetimeField,
  ],
);

class DeviceWithTime {
  DeviceWithTime({required this.device, required this.time});

  final DeviceDTO device;
  final Duration time;
}
