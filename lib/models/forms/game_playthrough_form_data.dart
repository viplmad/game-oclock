import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, GamePlaythrough;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class GamePlaythroughFormData extends FormData<GamePlaythrough> {
  final TextEditingController gameId;
  final TextEditingController name;

  GamePlaythroughFormData({required this.gameId, required this.name});

  @override
  void setValues(final GamePlaythrough? data) {
    gameId.setValue(data?.gameId);
    name.setValue(data?.name);
  }
}
