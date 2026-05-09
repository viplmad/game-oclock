import 'package:game_oclock/models/models.dart' show DeviceFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class DeviceFormBloc extends FormBloc<DeviceFormData, NewDeviceDTO, DeviceDTO> {
  DeviceFormBloc({required super.data});

  @override
  NewDeviceDTO fromFormData(final DeviceFormData data) {
    return NewDeviceDTO(
      name: data.name.value!,
      imageUrl: '', // TODO
    );
  }

  @override
  void setFormValue(final DeviceFormData data, final DeviceDTO? value) {
    data.name.value = value?.name;
  }
}
