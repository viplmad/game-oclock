import 'package:game_oclock/models/models.dart' show FormData, GameSession;
import 'package:reactive_forms/reactive_forms.dart';

class GameSessionFormData extends FormData<GameSession> {
  final FormControl<String> gameId;
  final FormControl<DateTime> startDateTime;
  final FormControl<DateTime> endDateTime;
  final FormControl<String> deviceId;
  final FormControl<String> playthroughId;
  final FormControl<bool> started;
  final FormControl<String> finished;

  GameSessionFormData({
    required this.gameId,
    required this.startDateTime,
    required this.endDateTime,
    required this.deviceId,
    required this.playthroughId,
    required this.started,
    required this.finished,
  }) : super(
         formGroup: FormGroup({
           'gameId': gameId,
           'startDateTime': startDateTime,
           'endDateTime': endDateTime,
           'deviceId': deviceId,
           'playthroughId': playthroughId,
           'started': started,
           'finished': finished,
         }),
       );
}
