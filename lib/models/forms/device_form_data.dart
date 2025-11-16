import 'package:game_oclock/models/models.dart' show Device, FormData;
import 'package:reactive_forms/reactive_forms.dart';

class DeviceFormData extends FormData<Device> {
  final FormControl<String> name;

  DeviceFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
