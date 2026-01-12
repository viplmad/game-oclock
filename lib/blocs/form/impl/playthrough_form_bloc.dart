import 'package:game_oclock/models/models.dart'
    show Playthrough, PlaythroughFormData;

import '../form.dart' show FormBloc;

class PlaythroughFormBloc extends FormBloc<PlaythroughFormData, Playthrough> {
  PlaythroughFormBloc({required super.data});

  @override
  Playthrough fromFormData(final PlaythroughFormData data) {
    return Playthrough(
      id: '', // TODO
      name: data.name.value!,
    );
  }

  @override
  void setFormValue(final PlaythroughFormData data, final Playthrough? value) {
    data.name.value = value?.name;
  }
}
