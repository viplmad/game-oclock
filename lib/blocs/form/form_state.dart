import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:game_oclock/models/models.dart' show ErrorDTO, FormGroup;

sealed class FormState2 extends Equatable {
  final widgets.GlobalKey<widgets.FormState> key;
  final FormGroup group;

  const FormState2({required this.key, required this.group});

  @override
  List<Object?> get props => [key, group];
}

final class FormStateInitial extends FormState2 {
  const FormStateInitial({required super.key, required super.group});
}

final class FormStateSubmitInProgress extends FormState2 {
  const FormStateSubmitInProgress({required super.key, required super.group});
}

final class FormStateSubmitSuccess extends FormState2 {
  final Map<String, dynamic> data;

  const FormStateSubmitSuccess({
    required this.data,
    required super.key,
    required super.group,
  });

  @override
  List<Object?> get props => [data, ...super.props];
}

final class FormStateSubmitFailure extends FormState2 {
  final ErrorDTO error;

  const FormStateSubmitFailure({
    required this.error,
    required super.key,
    required super.group,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
