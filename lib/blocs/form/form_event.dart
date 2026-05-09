import 'package:equatable/equatable.dart';

sealed class FormEvent<N, T> extends Equatable {
  const FormEvent();
}

final class FormSubmitted<N, T> extends FormEvent<N, T> {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}

final class FormValueUpdated<N, T> extends FormEvent<N, T> {
  final T? value;

  const FormValueUpdated({required this.value});

  @override
  List<Object?> get props => [value];
}
