import 'package:game_oclock/models/models.dart' show Location, LocationFormData;

import '../form.dart' show FormBloc;

class LocationFormBloc extends FormBloc<LocationFormData, Location> {
  LocationFormBloc({required super.data});

  @override
  Location fromFormData(final LocationFormData data) {
    return Location(
      id: '', // TODO
      name: data.name.value!,
      imageUrl: '', // TODO
    );
  }

  @override
  void setFormValue(final LocationFormData data, final Location? value) {
    data.name.value = value?.name;
  }
}
