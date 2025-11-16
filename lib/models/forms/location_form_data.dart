import 'package:game_oclock/models/models.dart' show FormData, Location;
import 'package:reactive_forms/reactive_forms.dart';

class LocationFormData extends FormData<Location> {
  final FormControl<String> name;

  LocationFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
