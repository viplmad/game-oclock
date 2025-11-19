import 'package:game_oclock/models/models.dart' show Device, DeviceFormData;

import '../form.dart' show FormBloc;

class DeviceFormBloc extends FormBloc<DeviceFormData, Device> {
  DeviceFormBloc({required super.data});

  @override
  Device fromFormData(final DeviceFormData data) {
    return Device(
      id: '', // TODO
      name: data.name.value!,
      iconUrl: '', // TODO
    );
  }

  @override
  void setFormValue(final DeviceFormData data, final Device? value) {
    data.name.value = value?.name;
  }
}
