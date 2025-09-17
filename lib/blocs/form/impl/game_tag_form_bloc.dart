import 'package:game_oclock/models/models.dart' show GameTag, GameTagFormData;

import '../form.dart' show FormBloc;

class GameTagFormBloc extends FormBloc<GameTagFormData, GameTag> {
  GameTagFormBloc({required super.formGroup});

  @override
  GameTag fromData(final GameTagFormData values) {
    return GameTag(
      gameId: values.gameId.value.text,
      tagId: values.tagId.value.text,
    );
  }
}
