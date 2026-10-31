import 'package:game_oclock/models/models.dart'
    show NewPlaythrough, Playthrough, PlaythroughFormData;

import '../form.dart' show FormBloc;

class PlaythroughFormBloc
    extends FormBloc<PlaythroughFormData, NewPlaythrough, Playthrough> {
  PlaythroughFormBloc({required super.data});

  @override
  NewPlaythrough fromFormData(PlaythroughFormData data) {
    return NewPlaythrough(name: data.name.value!);
  }

  @override
  void setFormValue(PlaythroughFormData data, Playthrough? value) {
    data.name.value = value?.name;
  }
}
