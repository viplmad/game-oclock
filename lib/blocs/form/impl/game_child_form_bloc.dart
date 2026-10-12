import 'package:game_oclock/models/models.dart'
    show GameChild, GameChildFormData;

import '../form.dart' show FormBloc;

class GameChildFormBloc
    extends FormBloc<GameChildFormData, GameChild, GameChild> {
  GameChildFormBloc({required super.data});

  @override
  GameChild fromFormData(final GameChildFormData data) {
    return GameChild(
      parentGameId: data.parentGameId.value!,
      childGameId: data.childGameId.value!,
      order: data.order.value == null ? null : int.tryParse(data.order.value!),
    );
  }

  @override
  void setFormValue(final GameChildFormData data, final GameChild? value) {
    data.parentGameId.value = value?.parentGameId;
    data.childGameId.value = value?.childGameId;
    data.order.value = value?.order?.toString();
  }
}
