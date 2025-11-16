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

abstract class FormBloc<D extends FormData<T>, T>
    extends Bloc<FormEvent<T>, FormState2<D, T>> {
  FormBloc({required final D data})
    : super(FormStateInitial<D, T>(data: data)) {
    on<FormSubmitted<T>>(
      (final event, final emit) async => await onSubmitted(emit),
    );
    on<FormValueUpdated<T>>(
      (final event, final emit) async =>
          await onValueUpdated(event.value, emit),
    );
  }

  Future<void> onSubmitted(final Emitter<FormState2> emit) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final data = state.data;

    emit(FormStateSubmitInProgress<D, T>(data: data));
    data.formGroup.updateValueAndValidity();
    if (data.formGroup.valid) {
      final value = fromFormData(data);
      emit(FormStateSubmitSuccess<D, T>(value: value, data: data));
    } else {
      emit(
        FormStateSubmitFailure<D, T>(
          error: ErrorDTO(
            code: errorCodeInvalidForm,
            message:
                'The form has ${data.formGroup.errors.length} errors', // TODO i18n
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
    emit(FormStateInitial<D, T>(data: data));
  }

  T fromFormData(final D data);

  void setFormValue(final D data, final T? value);
}
