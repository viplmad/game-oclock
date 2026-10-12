import 'package:game_oclock/models/models.dart' show FormData;
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LocationFormData extends FormData<NewLocationDTO> {
  final FormControl<String> name;
  final FormControl<String> imageUrl;

  LocationFormData({required this.name, required this.imageUrl})
    : super(formGroup: FormGroup({'name': name, 'imageUrl': imageUrl}));
}
