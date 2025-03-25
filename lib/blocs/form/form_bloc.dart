import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, FormGroup, errorCodeInvalidForm;

import 'form.dart'
    show
        FormEvent,
        FormState2,
        FormStateInitial,
        FormStateSubmitFailure,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted;

class FormBloc extends Bloc<FormEvent, FormState2> {
  FormBloc({required final FormGroup formGroup})
    : super(
        FormStateInitial(
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

    emit(FormStateSubmitInProgress(key: formKey, group: formGroup));
    final valid =
        formKey.currentState != null ? formKey.currentState!.validate() : false;
    if (valid) {
      formKey.currentState!.save();
      final Map<String, dynamic> values = formGroup.getValues();
      emit(
        FormStateSubmitSuccess(data: values, key: formKey, group: formGroup),
      );
    } else {
      emit(
        FormStateSubmitFailure(
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
}
