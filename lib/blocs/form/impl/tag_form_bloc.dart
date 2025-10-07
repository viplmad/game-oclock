import 'package:game_oclock/models/models.dart' show Tag, TagFormData;

import '../form.dart' show FormBloc;

class TagFormBloc extends FormBloc<TagFormData, Tag> {
  TagFormBloc({required super.formGroup});

  @override
  Tag fromData(final TagFormData values) {
    return Tag(
      id: 'kalmdkamsd', // TODO
      name: values.name.text,
    );
  }
}
