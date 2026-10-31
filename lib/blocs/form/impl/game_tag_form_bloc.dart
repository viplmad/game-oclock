import 'package:game_oclock/models/models.dart' show GameTag, GameTagFormData;

import '../form.dart' show FormBloc;

class GameTagFormBloc extends FormBloc<GameTagFormData, GameTag, GameTag> {
  GameTagFormBloc({required super.data});

  @override
  GameTag fromFormData(GameTagFormData data) {
    return GameTag(
      gameId: data.gameId.value!,
      tagId: data.tagId.value!,
      order: null,
    );
  }

  @override
  void setFormValue(GameTagFormData data, GameTag? value) {
    data.gameId.value = value?.gameId;
    data.tagId.value = value?.tagId;
  }
}
