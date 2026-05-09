import 'package:game_oclock/models/models.dart' show FormData;
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LocationFormData extends FormData<NewLocationDTO> {
  final FormControl<String> name;

  LocationFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
