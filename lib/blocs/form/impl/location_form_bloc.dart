import 'package:game_oclock/models/models.dart' show Location, LocationFormData;

import '../form.dart' show FormBloc;

class LocationFormBloc extends FormBloc<LocationFormData, Location> {
  LocationFormBloc({required super.formGroup});

  @override
  Location fromData(final LocationFormData values) {
    return Location(
      id: 'kalmdkamsd', // TODO
      name: values.name.text,
    );
  }
}
