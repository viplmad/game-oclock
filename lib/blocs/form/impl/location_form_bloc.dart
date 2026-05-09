import 'package:game_oclock/models/models.dart' show LocationFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class LocationFormBloc
    extends FormBloc<LocationFormData, NewLocationDTO, LocationDTO> {
  LocationFormBloc({required super.data});

  @override
  NewLocationDTO fromFormData(final LocationFormData data) {
    return NewLocationDTO(
      name: data.name.value!,
      imageUrl: '', // TODO
    );
  }

  @override
  void setFormValue(final LocationFormData data, final LocationDTO? value) {
    data.name.value = value?.name;
  }
}
