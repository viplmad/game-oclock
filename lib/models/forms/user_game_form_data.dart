import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show FormData, UserGame;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class UserGameFormData extends FormData<UserGame> {
  final TextEditingController title;
  final TextEditingController edition;
  final DateTimeEditingController releaseDate;
  final TextEditingController status;
  final ScalarNumberEditingController rating;
  final TextEditingController notes;
  final MultipleTextEditingController genres;
  final MultipleTextEditingController series;

  UserGameFormData({
    required this.title,
    required this.edition,
    required this.releaseDate,
    required this.status,
    required this.rating,
    required this.notes,
    required this.genres,
    required this.series,
  });

  @override
  void setValues(final UserGame? userGame) {
    title.setValue(userGame?.title);
    edition.setValue(userGame?.edition);
    releaseDate.setValue(userGame?.releaseDate);
    status.setValue(userGame?.status);
    rating.setValue(userGame?.rating);
    notes.setValue(userGame?.notes);
    genres.setValue(userGame?.genres);
    series.setValue(userGame?.series);
  }
}
