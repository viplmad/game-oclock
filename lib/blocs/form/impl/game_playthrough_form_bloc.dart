import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, GamePlaythroughFormData;

import '../form.dart' show FormBloc;

class GamePlaythroughFormBloc
    extends FormBloc<GamePlaythroughFormData, GamePlaythrough> {
  GamePlaythroughFormBloc({required super.data});

  @override
  GamePlaythrough fromFormData(final GamePlaythroughFormData data) {
    return GamePlaythrough(
      id: '', // TODO
      gameId: data.gameId.value!,
      name: data.name.value!,
    );
  }

  @override
  void setFormValue(
    final GamePlaythroughFormData data,
    final GamePlaythrough? value,
  ) {
    data.gameId.value = value?.gameId;
    data.name.value = value?.name;
  }
}
