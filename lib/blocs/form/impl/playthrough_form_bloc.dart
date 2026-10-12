import 'package:game_oclock/models/models.dart'
    show NewPlaythrough, Playthrough, PlaythroughFormData;

import '../form.dart' show FormBloc;

class PlaythroughFormBloc
    extends FormBloc<PlaythroughFormData, NewPlaythrough, Playthrough> {
  PlaythroughFormBloc({required super.data});

  @override
  NewPlaythrough fromFormData(final PlaythroughFormData data) {
    return NewPlaythrough(name: data.name.value!);
  }

  @override
  void setFormValue(final PlaythroughFormData data, final Playthrough? value) {
    data.name.value = value?.name;
  }
}
