import 'package:game_oclock/models/models.dart' show LocationFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class LocationFormBloc
    extends FormBloc<LocationFormData, NewLocationDTO, LocationDTO> {
  LocationFormBloc({required super.data});

  @override
  NewLocationDTO fromFormData(LocationFormData data) {
    return NewLocationDTO(
      name: data.name.value!,
      imageUrl: data.imageUrl.value,
    );
  }

  @override
  void setFormValue(LocationFormData data, LocationDTO? value) {
    data.name.value = value?.name;
  }
}
