import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, FormData, errorCodeInvalidForm;

import 'form.dart'
    show
        FormEvent,
        FormState2,
        FormStateInitial,
        FormStateSubmitFailure,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValueUpdated;

abstract class FormBloc<D extends FormData<N>, N, T>
    extends Bloc<FormEvent<N, T>, FormState2<D, N>> {
  FormBloc({required final D data})
    : super(FormStateInitial<D, N>(data: data)) {
    on<FormSubmitted<N, T>>(
      (final event, final emit) async => await onSubmitted(emit),
    );
    on<FormValueUpdated<N, T>>(
      (final event, final emit) async =>
          await onValueUpdated(event.value, emit),
    );
  }

  Future<void> onSubmitted(final Emitter<FormState2> emit) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final data = state.data;

    emit(FormStateSubmitInProgress<D, N>(data: data));
    data.formGroup.updateValueAndValidity();
    if (data.formGroup.valid) {
      final value = fromFormData(data);
      emit(FormStateSubmitSuccess<D, N>(value: value, data: data));
    } else {
      emit(
        FormStateSubmitFailure<D, N>(
          error: ErrorDTO(
            code: errorCodeInvalidForm,
            message: 'The form has ${data.formGroup.errors.length} errors',
          ),
          data: data,
        ),
      );
    }
  }

  Future<void> onValueUpdated(
    final T? value,
    final Emitter<FormState2> emit,
  ) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final data = state.data;
    setFormValue(data, value);
    emit(FormStateInitial<D, N>(data: data));
  }

  N fromFormData(final D data);

  void setFormValue(final D data, final T? value);
}
