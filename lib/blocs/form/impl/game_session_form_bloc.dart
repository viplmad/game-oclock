import 'package:game_oclock/models/models.dart'
    show GameSessionFormData, NewMediaSession;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class GameSessionFormBloc
    extends FormBloc<GameSessionFormData, NewMediaSession, SessionDTO> {
  GameSessionFormBloc({required super.data});

  @override
  NewMediaSession fromFormData(final GameSessionFormData data) {
    return NewMediaSession(
      gameId: data.gameId.value!,
      startDatetime: data.startDateTime.value!,
      endDatetime: data.endDateTime.value!,
      deviceId: data.deviceId.value!,
      groupId: data.playthroughId.value!,
      started: data.started.value!,
      finishedStatus: MediaStatus.fromJson(data.finished.value!),
    );
  }

  @override
  void setFormValue(final GameSessionFormData data, final SessionDTO? value) {
    data.startDateTime.value = value?.startDatetime;
    data.endDateTime.value = value?.endDatetime;
    data.deviceId.value = value?.deviceId;
    data.playthroughId.value = value?.groupId;
    data.started.value = value?.started;
    data.finished.value = value?.finishedStatus?.toJson();
  }
}
