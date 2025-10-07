import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, Tag;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class TagFormData extends FormData<Tag> {
  final TextEditingController name;

  TagFormData({required this.name});

  @override
  void setValues(final Tag? data) {
    name.setValue(data?.name);
  }
}
