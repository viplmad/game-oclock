import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, errorCodeInvalidForm;

import 'form.dart'
    show
        FormEvent,
        FormState2,
        FormStateInitial,
        FormStateSubmitFailure,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted;

abstract class FormBloc<D, T> extends Bloc<FormEvent, FormState2<D, T>> {
  FormBloc({required final D formGroup})
    : super(
        FormStateInitial<D, T>(
          key: widgets.GlobalKey<widgets.FormState>(),
          group: formGroup,
        ),
      ) {
    on<FormSubmitted>(
      (final event, final emit) async => await onSubmitted(emit),
    );
  }

  Future<void> onSubmitted(final Emitter<FormState2> emit) async {
    final formKey = state.key;
    final formGroup = state.group;

    emit(FormStateSubmitInProgress<D, T>(key: formKey, group: formGroup));
    final valid =
        formKey.currentState != null ? formKey.currentState!.validate() : false;
    if (valid) {
      formKey.currentState!.save();
      final data = fromDynamicMap(formGroup);
      emit(
        FormStateSubmitSuccess<D, T>(
          data: data,
          key: formKey,
          group: formGroup,
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
        ),
      );
    }
  }

  T fromDynamicMap(final D values);
}
