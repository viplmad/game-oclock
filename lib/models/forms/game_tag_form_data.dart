import 'package:game_oclock/models/models.dart' show FormData, GameTag;
import 'package:reactive_forms/reactive_forms.dart';

class GameTagFormData extends FormData<GameTag> {
  final FormControl<String> gameId;
  final FormControl<String> tagId;

  GameTagFormData({required this.gameId, required this.tagId})
    : super(formGroup: FormGroup({'gameId': gameId, 'tagId': tagId}));
}
