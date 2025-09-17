import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, UserGame;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class UserGameFormData extends FormData<UserGame> {
  final TextEditingController title;
  final TextEditingController edition;
  final TextEditingController status;
  final TextEditingController rating;
  final TextEditingController notes;

  UserGameFormData({
    required this.title,
    required this.edition,
    required this.status,
    required this.rating,
    required this.notes,
  });

  @override
  void setValues(final UserGame? userGame) {
    title.setValue(userGame?.title);
    edition.setValue(userGame?.edition);
    status.setValue(userGame?.status);
    rating.setValue(userGame?.rating.toString());
    notes.setValue(userGame?.notes);
  }
}
