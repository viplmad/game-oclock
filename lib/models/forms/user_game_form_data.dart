import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, UserGame;

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
    title.value = title.value.copyWith(text: userGame?.title);
    edition.value = edition.value.copyWith(text: userGame?.edition);
    status.value = status.value.copyWith(text: userGame?.status);
    rating.value = rating.value.copyWith(text: userGame?.rating.toString());
    notes.value = notes.value.copyWith(text: userGame?.notes);
  }
}
