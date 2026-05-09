import 'package:game_oclock/models/models.dart'
    show GameAvailable, GameAvailableFormData;

import '../form.dart' show FormBloc;

class GameAvailableFormBloc
    extends FormBloc<GameAvailableFormData, GameAvailable, GameAvailable> {
  GameAvailableFormBloc({required super.data});

  @override
  GameAvailable fromFormData(final GameAvailableFormData data) {
    return GameAvailable(
      gameId: data.gameId.value!,
      locationId: data.locationId.value!,
      date: data.date.value!,
    );
  }

  @override
  void setFormValue(
    final GameAvailableFormData data,
    final GameAvailable? value,
  ) {
    data.gameId.value = value?.gameId;
    data.locationId.value = value?.locationId;
    data.date.value = value?.date;
  }
}
