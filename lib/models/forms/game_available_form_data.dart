import 'package:game_oclock/models/models.dart' show FormData, GameAvailable;
import 'package:reactive_forms/reactive_forms.dart';

class GameAvailableFormData extends FormData<GameAvailable> {
  final FormControl<String> gameId;
  final FormControl<String> locationId;
  final FormControl<DateTime> date;

  GameAvailableFormData({
    required this.gameId,
    required this.locationId,
    required this.date,
  }) : super(
         formGroup: FormGroup({
           'gameId': gameId,
           'locationId': locationId,
           'date': date,
         }),
       );
}
