import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, GameTag;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class GameTagFormData extends FormData<GameTag> {
  final TextEditingController gameId;
  final TextEditingController tagId;

  GameTagFormData({required this.gameId, required this.tagId});

  @override
  void setValues(final GameTag? gameTag) {
    gameId.setValue(gameTag?.gameId);
    tagId.setValue(gameTag?.tagId);
  }
}
