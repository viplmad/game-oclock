import 'package:game_oclock/models/models.dart'
    show GameSession, GameSessionFormData;

import '../form.dart' show FormBloc;

class GameSessionFormBloc extends FormBloc<GameSessionFormData, GameSession> {
  GameSessionFormBloc({required super.formGroup});

  @override
  GameSession fromData(final GameSessionFormData values) {
    return GameSession(
      gameId: values.gameId.text,
      start: values.startDateTime.value!,
      end: values.endDateTime.value!,
      deviceId: values.deviceId.text,
      playthroughId: values.playthroughId.text,
      started: values.started.value!,
      finished: values.finished.text,
    );
  }
}
