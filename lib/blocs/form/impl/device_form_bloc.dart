import 'package:game_oclock/models/models.dart' show Device, DeviceFormData;

import '../form.dart' show FormBloc;

class DeviceFormBloc extends FormBloc<DeviceFormData, Device> {
  DeviceFormBloc({required super.formGroup});

  @override
  Device fromData(final DeviceFormData values) {
    return Device(
      id: 'kalmdkamsd', // TODO
      name: values.name.text,
    );
  }
}
