import 'package:equatable/equatable.dart';

sealed class FormEvent<T> extends Equatable {
  const FormEvent();
}

final class FormSubmitted<T> extends FormEvent<T> {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}

final class FormValueUpdated<T> extends FormEvent<T> {
  final T? value;

  const FormValueUpdated({required this.value});

  @override
  List<Object?> get props => [value];
}
