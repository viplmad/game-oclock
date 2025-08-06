import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show FormData, UserGame;

import 'form.dart' show FormBloc;

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

class UserGameFormBloc extends FormBloc<UserGameFormData, UserGame> {
  UserGameFormBloc({required super.formGroup});

  @override
  UserGame fromData(final UserGameFormData values) {
    return UserGame(
      id: 'kalmdkamsd',
      externalId: 'epic',
      title: values.title.value.text,
      edition: values.edition.value.text,
      releaseDate: DateTime.now(),
      genres: [],
      series: [],
      coverUrl: '',
      status: values.status.value.text,
      rating: int.tryParse(values.rating.value.text) ?? 0,
      notes: values.notes.value.text,
    );
  }
}
