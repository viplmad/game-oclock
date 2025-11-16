import 'package:game_oclock/models/models.dart' show Tag, TagFormData;

import '../form.dart' show FormBloc;

class TagFormBloc extends FormBloc<TagFormData, Tag> {
  TagFormBloc({required super.data});

  @override
  Tag fromFormData(final TagFormData data) {
    return Tag(
      id: '', // TODO
      name: data.name.value!,
    );
  }

  @override
  void setFormValue(final TagFormData data, final Tag? value) {
    data.name.value = value?.name;
  }
}
