import 'package:equatable/equatable.dart';

sealed class FormEvent extends Equatable {
  const FormEvent();
}

final class FormSubmitted extends FormEvent {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}
