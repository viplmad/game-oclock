import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, GamePlaythroughFormData;

import '../form.dart' show FormBloc;

class GamePlaythroughFormBloc
    extends FormBloc<GamePlaythroughFormData, GamePlaythrough> {
  GamePlaythroughFormBloc({required super.formGroup});

  @override
  GamePlaythrough fromData(final GamePlaythroughFormData values) {
    return GamePlaythrough(
      id: 'kalmdkamsd', // TODO
      gameId: values.gameId.text,
      name: values.name.text,
    );
  }
}
