import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show Device, FormData;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class DeviceFormData extends FormData<Device> {
  final TextEditingController name;

  DeviceFormData({required this.name});

  @override
  void setValues(final Device? data) {
    name.setValue(data?.name);
  }
}
