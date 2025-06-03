import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ConsumerActionBloc,
        FormBloc,
        FormDirtied,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValuesUpdated,
        FunctionActionBloc,
        LayoutTierBloc,
        LayoutTierState;
import 'package:game_oclock/models/models.dart' show FormData, LayoutTier;

class CreateEditFormBuilder<
  T,
  D extends FormData<T>,
  FB extends FormBloc<D, T>,
  GB extends FunctionActionBloc<String, T?>,
  CB extends ConsumerActionBloc<T>,
  UB extends ConsumerActionBloc<T>
>
    extends StatelessWidget {
  const CreateEditFormBuilder({
    super.key,
    required this.title,
    required this.create,
    required this.fieldsBuilder,
  });

  final bool create;
  final String title;

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, D formGroup, bool readOnly)
  fieldsBuilder;

  @override
  Widget build(final BuildContext context) {
    if (create) {
      return BlocBuilder<LayoutTierBloc, LayoutTierState>(
        builder: (final context, final layoutState) {
          final fullscreen = layoutState.tier == LayoutTier.compact;

          final form = buildCreateForm(context, fullscreen: fullscreen);
          return fullscreen
              ? Dialog.fullscreen(child: form)
              : Dialog(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560.0),
                  child: form,
                ),
              );
        },
      );
    } else {
      return BlocBuilder<LayoutTierBloc, LayoutTierState>(
        builder: (final context, final layoutState) {
          final fullscreen = layoutState.tier == LayoutTier.compact;

          final form = buildEditForm(context, fullscreen: fullscreen);
          return fullscreen
              ? Dialog.fullscreen(child: form)
              : Dialog(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560.0),
                  child: form,
                ),
              );
        },
      );
    }
  }

  Widget buildCreateForm(
    final BuildContext context, {
    required final bool fullscreen,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FB, FormState2<D, T>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<D, T>) {
              context.read<CB>().add(ActionStarted(data: state.data));
            }
          },
        ),
        BlocListener<CB, ActionState<void>>(
          listener: (final context, final state) {
            final snackBar = SnackBar(content: Text('Data created $state'));
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // TODO possibly clear dirty now
          },
        ),
      ],
      child: BlocBuilder<FB, FormState2<D, T>>(
        builder: (final context, final formState) {
          return BlocBuilder<CB, ActionState<void>>(
            builder: (final context, final createState) {
              final inProgress =
                  formState is FormStateSubmitInProgress ||
                  createState is ActionInProgress;

              return FullForm(
                title: title,
                formKey: formState.key,
                fullscreen: fullscreen,
                formFieldsContainer: fieldsBuilder(
                  context,
                  formState.group,
                  inProgress,
                ),
                dirty: formState.dirty,
                onChanged: () => context.read<FB>().add(const FormDirtied()),
                onSubmit:
                    inProgress
                        ? null
                        : () {
                          context.read<FB>().add(const FormSubmitted());
                        },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildEditForm(
    final BuildContext context, {
    required final bool fullscreen,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FB, FormState2<D, T>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<D, T>) {
              context.read<UB>().add(ActionStarted(data: state.data));
            }
          },
        ),
        BlocListener<UB, ActionState<void>>(
          listener: (final context, final state) {
            final snackBar = SnackBar(content: Text('Data updated $state'));
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // TODO possibly clear dirty now
          },
        ),
        BlocListener<GB, ActionState<T?>>(
          listener: (final context, final state) {
            if (state is ActionFinal<T?>) {
              final T? data = state.data;
              if (data != null) {
                context.read<FB>().add(FormValuesUpdated(values: data));
              }
            }
          },
        ),
      ],
      child: BlocBuilder<FB, FormState2<D, T>>(
        builder: (final context, final formState) {
          return BlocBuilder<GB, ActionState<T?>>(
            builder: (final context, final getState) {
              bool skeleton = false; // TODO
              if (getState is ActionInProgress<T>) {
                skeleton = true; // TODO only if initial load?
              }

              return BlocBuilder<UB, ActionState<void>>(
                builder: (final context, final createState) {
                  final inProgress =
                      getState is ActionInProgress ||
                      formState is FormStateSubmitInProgress ||
                      createState is ActionInProgress;

                  return FullForm(
                    title: title,
                    formKey: formState.key,
                    fullscreen: fullscreen,
                    formFieldsContainer: fieldsBuilder(
                      context,
                      formState.group,
                      inProgress,
                    ),
                    dirty: formState.dirty,
                    onChanged:
                        () => context.read<FB>().add(const FormDirtied()),
                    onSubmit: // TODO possibly disallow submit if not dirty
                        inProgress
                            ? null
                            : () {
                              context.read<FB>().add(const FormSubmitted());
                            },
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

/// https://m3.material.io/components/dialogs/guidelines#9d723c7a-03d1-4e7c-95af-a20ed4b66533
class FullForm extends StatelessWidget {
  const FullForm({
    super.key,
    required this.title,
    required this.formKey,
    required this.fullscreen,
    required this.dirty,
    required this.formFieldsContainer,
    required this.onChanged,
    this.onSubmit,
  });

  final String title;
  final Key formKey;
  final bool fullscreen;
  final bool dirty;
  final Widget formFieldsContainer;
  final VoidCallback onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(final BuildContext context) {
    final inProgress = onSubmit == null;
    final saveButton = TextButton.icon(
      icon: inProgress ? const CircularProgressIndicator() : null,
      label: const Text('Save'), // TODO i18n
      onPressed: onSubmit,
    );

    final form = Form(
      key: formKey,
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) async {
        if (didPop) {
          return;
        }
        if (inProgress) {
          return;
        }

        final bool shouldPop =
            dirty ? await _showBackDialog(context) ?? false : true;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      onChanged: inProgress ? null : onChanged,
      child: formFieldsContainer,
    );

    final modifiedChip =
        dirty
            ? IgnorePointer(
              child: ActionChip(
                label: const Text('Modified'),
                onPressed: () => {},
              ),
            )
            : const SizedBox();

    return fullscreen
        ? Scaffold(
          appBar: AppBar(
            title: Text(title),
            automaticallyImplyLeading: false,
            leading: CloseButton(
              onPressed:
                  inProgress ? null : () async => Navigator.maybePop(context),
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
                          onPressed:
                              inProgress
                                  ? null
                                  : () async => Navigator.maybePop(context),
                          child: const Text('Cancel'), // TODO i18n
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

  Future<bool?> _showBackDialog(final BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (final context) {
        return AlertDialog(
          title: const Text('Are you sure?'), // TODO i18n
          content: const Text(
            'Are you sure you want to leave this page?',
          ), // TODO i18n
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Stay'), // TODO i18n
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Discard'), // TODO i18n
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
