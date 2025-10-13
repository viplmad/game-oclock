import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show FormData, GameSession;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class GameSessionFormData extends FormData<GameSession> {
  final TextEditingController gameId;
  final DateTimeEditingController startDateTime;
  final DateTimeEditingController endDateTime;
  final TextEditingController deviceId;
  final TextEditingController playthroughId;
  final BoolEditingController started;
  final TextEditingController finished;

  GameSessionFormData({
    required this.gameId,
    required this.startDateTime,
    required this.endDateTime,
    required this.deviceId,
    required this.playthroughId,
    required this.started,
    required this.finished,
  });

  @override
  void setValues(final GameSession? data) {
    gameId.setValue(data?.gameId);
    startDateTime.setValue(data?.start);
    endDateTime.setValue(data?.end);
    deviceId.setValue(data?.deviceId);
    playthroughId.setValue(data?.playthroughId);
    started.setValue(data?.started);
    finished.setValue(data?.finished);
  }
}
