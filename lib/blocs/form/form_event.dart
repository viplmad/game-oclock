import 'package:equatable/equatable.dart';

sealed class FormEvent<T> extends Equatable {
  const FormEvent();
}

final class FormSubmitted<T> extends FormEvent<T> {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}

final class FormDirtied<T> extends FormEvent<T> {
  const FormDirtied();

  @override
  List<Object?> get props => [];
}

final class FormValuesUpdated<T> extends FormEvent<T> {
  final T? values;

  const FormValuesUpdated({required this.values});

  @override
  List<Object?> get props => [values];
}
