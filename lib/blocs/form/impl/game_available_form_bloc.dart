import 'package:game_oclock/models/models.dart'
    show GameAvailable, GameAvailableFormData;

import '../form.dart' show FormBloc;

class GameAvailableFormBloc
    extends FormBloc<GameAvailableFormData, GameAvailable> {
  GameAvailableFormBloc({required super.formGroup});

  @override
  GameAvailable fromData(final GameAvailableFormData values) {
    return GameAvailable(
      gameId: values.gameId.text,
      locationId: values.locationId.text,
      date: values.date.value!, // UI validation should prevent null pointer
    );
  }
}
