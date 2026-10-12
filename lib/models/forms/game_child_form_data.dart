import 'package:game_oclock/models/models.dart' show FormData, GameChild;
import 'package:reactive_forms/reactive_forms.dart';

class GameChildFormData extends FormData<GameChild> {
  final FormControl<String> parentGameId;
  final FormControl<String> childGameId;
  final FormControl<String> order;

  GameChildFormData({
    required this.parentGameId,
    required this.childGameId,
    required this.order,
  }) : super(
         formGroup: FormGroup({
           'parentGameId': parentGameId,
           'childGameId': childGameId,
           'order': order,
         }),
       );
}
