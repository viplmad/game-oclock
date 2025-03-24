import 'package:flutter/widgets.dart' as widgets;
import 'package:game_oclock/models/models.dart' show ErrorDTO, FormGroup;

sealed class FormState2 {
  final widgets.GlobalKey<widgets.FormState> key;
  final FormGroup group;

  FormState2({required this.key, required this.group});
}

final class FormStateInitial extends FormState2 {
  FormStateInitial({required super.key, required super.group});
}

final class FormStateSubmitInProgress extends FormState2 {
  FormStateSubmitInProgress({required super.key, required super.group});
}

final class FormStateSubmitSuccess extends FormState2 {
  FormStateSubmitSuccess({required super.key, required super.group});
}

final class FormStateSubmitFailure extends FormState2 {
  final ErrorDTO error;

  FormStateSubmitFailure({
    required this.error,
    required super.key,
    required super.group,
  });
}
