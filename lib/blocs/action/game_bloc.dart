import 'package:flutter/widgets.dart';
import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show FormData, UserGame;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

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

class UserGameGetBloc extends FunctionActionBloc<String, UserGame> {
  @override
  Future<ActionFinal<UserGame>> doAction(
    final String event,
    final UserGame? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: mockUserGame());
  }
}

class UserGameCreateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty();
  }
}

class UserGameUpdateBloc extends ConsumerActionBloc<UserGame> {
  @override
  Future<ActionFinal<void>> doAction(
    final UserGame event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}

class UserGameSelectBloc extends FunctionActionBloc<UserGame?, UserGame?> {
  @override
  Future<ActionFinal<UserGame?>> doAction(
    final UserGame? event,
    final UserGame? lastData,
  ) async {
    return ActionSuccess(data: event);
  }
}
