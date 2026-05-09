import 'package:game_oclock/models/models.dart' show FormData;
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TagFormData extends FormData<NewTagDTO> {
  final FormControl<String> name;

  TagFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
