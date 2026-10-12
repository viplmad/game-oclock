import 'package:game_oclock/models/models.dart' show FormData, NewPlaythrough;
import 'package:reactive_forms/reactive_forms.dart';

class PlaythroughFormData extends FormData<NewPlaythrough> {
  final FormControl<String> name;

  PlaythroughFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
