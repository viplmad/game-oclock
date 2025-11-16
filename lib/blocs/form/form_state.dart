import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO;

sealed class FormState2<D, T> extends Equatable {
  final D data;

  const FormState2({required this.data});

  @override
  List<Object?> get props => [data];
}

final class FormStateInitial<D, T> extends FormState2<D, T> {
  const FormStateInitial({required super.data});
}

final class FormStateSubmitInProgress<D, T> extends FormState2<D, T> {
  const FormStateSubmitInProgress({required super.data});
}

final class FormStateSubmitSuccess<D, T> extends FormState2<D, T> {
  final T value;

  const FormStateSubmitSuccess({required this.value, required super.data});

  @override
  List<Object?> get props => [value, ...super.props];
}

final class FormStateSubmitFailure<D, T> extends FormState2<D, T> {
  final ErrorDTO error;

  const FormStateSubmitFailure({required this.error, required super.data});

  @override
  List<Object?> get props => [error, ...super.props];
}
