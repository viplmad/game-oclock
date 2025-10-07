import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, Location;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class LocationFormData extends FormData<Location> {
  final TextEditingController name;

  LocationFormData({required this.name});

  @override
  void setValues(final Location? data) {
    name.setValue(data?.name);
  }
}
