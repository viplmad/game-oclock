import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show FormData, GameAvailable;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class GameAvailableFormData extends FormData<GameAvailable> {
  final TextEditingController gameId;
  final TextEditingController locationId;
  final DateTimeEditingController date;

  GameAvailableFormData({
    required this.gameId,
    required this.locationId,
    required this.date,
  });

  @override
  void setValues(final GameAvailable? gameAvailable) {
    gameId.setValue(gameAvailable?.gameId);
    locationId.setValue(gameAvailable?.locationId);
    date.setValue(gameAvailable?.date);
  }
}
