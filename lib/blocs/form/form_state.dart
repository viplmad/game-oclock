import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:game_oclock/models/models.dart' show ErrorDTO;

sealed class FormState2<D, T> extends Equatable {
  final widgets.GlobalKey<widgets.FormState> key;
  final D group;

  const FormState2({required this.key, required this.group});

  @override
  List<Object?> get props => [key, group];
}

final class FormStateInitial<D, T> extends FormState2<D, T> {
  const FormStateInitial({required super.key, required super.group});
}

final class FormStateSubmitInProgress<D, T> extends FormState2<D, T> {
  const FormStateSubmitInProgress({required super.key, required super.group});
}

final class FormStateSubmitSuccess<D, T> extends FormState2<D, T> {
  final T data;

  const FormStateSubmitSuccess({
    required this.data,
    required super.key,
    required super.group,
  });

  @override
  List<Object?> get props => [data, ...super.props];
}

final class FormStateSubmitFailure<D, T> extends FormState2<D, T> {
  final ErrorDTO error;

  const FormStateSubmitFailure({
    required this.error,
    required super.key,
    required super.group,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
