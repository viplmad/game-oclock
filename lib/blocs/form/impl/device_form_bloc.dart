import 'package:game_oclock/models/models.dart' show DeviceFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class DeviceFormBloc extends FormBloc<DeviceFormData, NewDeviceDTO, DeviceDTO> {
  DeviceFormBloc({required super.data});

  @override
  NewDeviceDTO fromFormData(DeviceFormData data) {
    return NewDeviceDTO(name: data.name.value!, imageUrl: data.imageUrl.value);
  }

  @override
  void setFormValue(DeviceFormData data, DeviceDTO? value) {
    data.name.value = value?.name;
  }
}
