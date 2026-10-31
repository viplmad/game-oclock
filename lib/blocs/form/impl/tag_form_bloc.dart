import 'package:game_oclock/models/models.dart' show TagFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class TagFormBloc extends FormBloc<TagFormData, NewTagDTO, TagDTO> {
  TagFormBloc({required super.data});

  @override
  NewTagDTO fromFormData(TagFormData data) {
    return NewTagDTO(name: data.name.value!);
  }

  @override
  void setFormValue(TagFormData data, TagDTO? value) {
    data.name.value = value?.name;
  }
}
