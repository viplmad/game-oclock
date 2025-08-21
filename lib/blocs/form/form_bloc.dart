import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, FormData, errorCodeInvalidForm;

import 'form.dart'
    show
        FormDirtied,
        FormEvent,
        FormState2,
        FormStateInitial,
        FormStateSubmitFailure,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValuesUpdated;

abstract class FormBloc<D extends FormData<T>, T>
    extends Bloc<FormEvent<T>, FormState2<D, T>> {
  FormBloc({required final D formGroup})
    : super(
        FormStateInitial<D, T>(
          key: widgets.GlobalKey<widgets.FormState>(),
          group: formGroup,
          dirty: false,
        ),
      ) {
    on<FormSubmitted<T>>(
      (final event, final emit) async => await onSubmitted(emit),
    );
    on<FormDirtied<T>>(
      (final event, final emit) async => await onDirtied(emit),
    );
    on<FormValuesUpdated<T>>(
      (final event, final emit) async =>
          await onValuesUpdated(event.values, emit),
    );
  }

  Future<void> onSubmitted(final Emitter<FormState2> emit) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final formKey = state.key;
    final formGroup = state.group;
    final dirty = state.dirty;

    emit(
      FormStateSubmitInProgress<D, T>(
        key: formKey,
        group: formGroup,
        dirty: dirty,
      ),
    );
    final valid =
        formKey.currentState == null ? false : formKey.currentState!.validate();
    if (valid) {
      formKey.currentState!.save();
      final data = fromData(formGroup);
      emit(
        FormStateSubmitSuccess<D, T>(
          data: data,
          key: formKey,
          group: formGroup,
          dirty: false,
        ),
      );
    } else {
      emit(
        FormStateSubmitFailure<D, T>(
          error: ErrorDTO(
            code: errorCodeInvalidForm,
            message: formKey.currentState.toString(),
          ),
          key: formKey,
          group: formGroup,
          dirty: dirty,
        ),
      );
    }
  }

  Future<void> onDirtied(final Emitter<FormState2> emit) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final formKey = state.key;
    final formGroup = state.group;

    emit(FormStateInitial<D, T>(key: formKey, group: formGroup, dirty: true));
  }

  Future<void> onValuesUpdated(
    final T? values,
    final Emitter<FormState2> emit,
  ) async {
    if (state is FormStateSubmitInProgress) {
      return;
    }

    final formKey = state.key;
    final formGroup = state.group;

    formGroup.setValues(values);
    emit(FormStateInitial<D, T>(key: formKey, group: formGroup, dirty: false));
  }

  T fromData(final D values);
}
