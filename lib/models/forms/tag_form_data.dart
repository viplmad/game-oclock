import 'package:game_oclock/models/models.dart' show FormData, Tag;
import 'package:reactive_forms/reactive_forms.dart';

class TagFormData extends FormData<Tag> {
  final FormControl<String> name;

  TagFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
