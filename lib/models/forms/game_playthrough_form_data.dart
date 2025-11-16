import 'package:game_oclock/models/models.dart' show FormData, GamePlaythrough;
import 'package:reactive_forms/reactive_forms.dart';

class GamePlaythroughFormData extends FormData<GamePlaythrough> {
  final FormControl<String> gameId;
  final FormControl<String> name;

  GamePlaythroughFormData({required this.gameId, required this.name})
    : super(formGroup: FormGroup({'gameId': gameId, 'name': name}));
}
