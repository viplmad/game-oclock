import 'package:game_oclock/models/models.dart' show FormData, Playthrough;
import 'package:reactive_forms/reactive_forms.dart';

class PlaythroughFormData extends FormData<Playthrough> {
  final FormControl<String> name;

  PlaythroughFormData({required this.name})
    : super(formGroup: FormGroup({'name': name}));
}
