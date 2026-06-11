import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        ConsumerActionBloc,
        FormBloc,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValueUpdated,
        FunctionActionBloc;
import 'package:game_oclock/components/label_chip.dart';
import 'package:game_oclock/components/progress_button_icon.dart';
import 'package:game_oclock/models/models.dart' show FormData, LayoutTier;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateFormBuilder<
  N,
  T,
  K,
  D extends FormData<N>,
  FB extends FormBloc<D, N, T>,
  CB extends FunctionActionBloc<N, K>
>
    extends _FormBuilder<N, D> {
  const CreateFormBuilder({
    super.key,
    required super.title,
    required super.fieldsBuilder,
  });

  @override
  Widget buildForm(
    final BuildContext context, {
    required final bool fullscreen,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FB, FormState2<D, N>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<D, N>) {
              context.read<CB>().add(ActionStarted(data: state.value));
            }
          },
        ),
        BlocListener<CB, ActionState<K>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<K, N>) {
              showSnackBar(
                context,
                message: context.localize().createdSuccessfullyLabel,
              );
              Navigator.pop(context, state.data);
            }
            if (state is ActionFailure<K, N>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToCreateLabel,
                error: state.error,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<FB, FormState2<D, N>>(
        builder: (final context, final formState) {
          return BlocBuilder<CB, ActionState<K>>(
            builder: (final context, final createState) {
              final inProgress =
                  formState is FormStateSubmitInProgress ||
                  createState is ActionInProgress;

              return FullForm(
                title: title,
                formGroup: formState.data.formGroup,
                fullscreen: fullscreen,
                onSubmit: inProgress
                    ? null
                    : () {
                        context.read<FB>().add(const FormSubmitted());
                      },
                child: fieldsBuilder(context, formState.data, inProgress),
              );
            },
          );
        },
      ),
    );
  }
}

class EditFormBuilder<
  N,
  T,
  D extends FormData<N>,
  FB extends FormBloc<D, N, T>,
  GB extends FunctionActionBloc<String, T>,
  UB extends ConsumerActionBloc<N>
>
    extends _FormBuilder<N, D> {
  const EditFormBuilder({
    super.key,
    required super.title,
    required super.fieldsBuilder,
  });

  @override
  Widget buildForm(
    final BuildContext context, {
    required final bool fullscreen,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FB, FormState2<D, N>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<D, N>) {
              context.read<UB>().add(ActionStarted(data: state.value));
            }
          },
        ),
        BlocListener<UB, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, N>) {
              showSnackBar(
                context,
                message: context.localize().updatedSuccessfullyLabel,
              );
              Navigator.pop(context, state.event);
            }
            if (state is ActionFailure<N, N>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToUpdateLabel,
                error: state.error,
              );
            }
          },
        ),
        BlocListener<GB, ActionState<T>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<T, String>) {
              final T? data = state.data;
              if (data != null) {
                context.read<FB>().add(FormValueUpdated(value: data));
              }
            }
          },
        ),
      ],
      child: BlocBuilder<FB, FormState2<D, N>>(
        builder: (final context, final formState) {
          return BlocBuilder<GB, ActionState<T>>(
            builder: (final context, final getState) {
              return BlocBuilder<UB, ActionState<void>>(
                builder: (final context, final createState) {
                  final inProgress =
                      getState is ActionInProgress ||
                      formState is FormStateSubmitInProgress ||
                      createState is ActionInProgress;

                  return FullForm(
                    title: title,
                    formGroup: formState.data.formGroup,
                    fullscreen: fullscreen,
                    onSubmit: inProgress
                        ? null
                        : () {
                            context.read<FB>().add(const FormSubmitted());
                          },
                    child: fieldsBuilder(context, formState.data, inProgress),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

abstract class _FormBuilder<T, D extends FormData<T>> extends StatelessWidget {
  const _FormBuilder({
    super.key,
    required this.title,
    required this.fieldsBuilder,
  });

  final String title;

  final Widget Function(
    BuildContext context,
    D formGroup,
    // ignore: avoid_positional_boolean_parameters
    bool readOnly,
  )
  fieldsBuilder;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);
    final fullscreen = layoutTier == LayoutTier.compact;

    final form = buildForm(context, fullscreen: fullscreen);
    return fullscreen
        ? Dialog.fullscreen(child: form)
        : Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560.0),
              child: form,
            ),
          );
  }

  Widget buildForm(
    final BuildContext context, {
    required final bool fullscreen,
  });
}

/// https://m3.material.io/components/dialogs/guidelines#9d723c7a-03d1-4e7c-95af-a20ed4b66533
class FullForm extends StatelessWidget {
  const FullForm({
    super.key,
    required this.title,
    required this.formGroup,
    required this.fullscreen,
    required this.child,
    this.onSubmit,
  });

  final String title;
  final FormGroup formGroup;
  final bool fullscreen;
  final Widget child;
  final VoidCallback? onSubmit;

  @override
  Widget build(final BuildContext context) {
    final inProgress = onSubmit == null;
    final saveButton = TextButton.icon(
      icon: inProgress ? const ProgressButtonIcon() : null,
      label: Text(context.localize().saveLabel),
      onPressed: onSubmit,
    );

    final form = ReactiveForm(
      formGroup: formGroup,
      // Can pop only if it is pristine (not dirty)
      canPop: (final formGroup) => formGroup.pristine,
      onPopInvokedWithResult:
          (final formGroup, final didPop, final result) async {
            if (didPop) {
              return;
            }
            if (inProgress) {
              return;
            }

            final bool shouldPop = formGroup.pristine
                ? true
                : await _showLeaveConfirmationDialog(context) ?? false;
            if (shouldPop && context.mounted) {
              Navigator.pop(context);
            }
          },
      child: child,
    );

    final modifiedChip = formGroup.pristine
        ? const SizedBox()
        : LabelChip(label: context.localize().modifiedLabel);

    return fullscreen
        ? Scaffold(
            appBar: AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
              leading: CloseButton(
                onPressed: inProgress
                    ? null
                    : () async => await Navigator.maybePop(context),
              ),
              actions: [modifiedChip, const SizedBox(width: 16.0), saveButton],
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
                left: 24.0,
                right: 24.0,
              ),
              child: SingleChildScrollView(child: form),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextStyle(
                  style:
                      DialogTheme.of(context).titleTextStyle ??
                      Theme.of(context).textTheme.headlineSmall!,
                  textAlign: TextAlign.start,
                  child: Text(title),
                ),
                const SizedBox(height: 16.0),
                Flexible(child: SingleChildScrollView(child: form)),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    modifiedChip,
                    Expanded(
                      child: OverflowBar(
                        alignment: MainAxisAlignment.end,
                        spacing: 16 / 2,
                        overflowAlignment: OverflowBarAlignment.end,
                        overflowDirection: VerticalDirection.down,
                        overflowSpacing: 0,
                        children: [
                          TextButton(
                            onPressed: inProgress
                                ? null
                                : () async => await Navigator.maybePop(context),
                            child: Text(context.localize().cancelLabel),
                          ),
                          saveButton,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Future<bool?> _showLeaveConfirmationDialog(final BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (final context) {
        return AlertDialog(
          title: Text(context.localize().leaveDirtyFormConfirmationDialogTitle),
          content: Text(
            context.localize().leaveDirtyFormConfirmationDialogSubtitle,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.localize().stayLabel),
              onPressed: () async => await Navigator.maybePop(context, false),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.localize().discardChangesLabel),
              onPressed: () async => await Navigator.maybePop(context, true),
            ),
          ],
        );
      },
    );
  }
}
