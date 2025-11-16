import 'package:game_oclock/models/models.dart'
    show GameSession, GameSessionFormData;

import '../form.dart' show FormBloc;

class GameSessionFormBloc extends FormBloc<GameSessionFormData, GameSession> {
  GameSessionFormBloc({required super.data});

  @override
  GameSession fromFormData(final GameSessionFormData data) {
    return GameSession(
      gameId: data.gameId.value!,
      start: data.startDateTime.value!,
      end: data.endDateTime.value!,
      deviceId: data.deviceId.value!,
      playthroughId: data.playthroughId.value!,
      started: data.started.value!,
      finished: data.finished.value!,
    );
  }

  @override
  void setFormValue(final GameSessionFormData data, final GameSession? value) {
    data.gameId.value = value?.gameId;
    data.startDateTime.value = value?.start;
    data.endDateTime.value = value?.end;
    data.deviceId.value = value?.deviceId;
    data.playthroughId.value = value?.playthroughId;
    data.started.value = value?.started;
    data.finished.value = value?.finished;
  }
}
