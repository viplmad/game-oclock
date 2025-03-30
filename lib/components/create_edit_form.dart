import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionInProgress,
        ActionStarted,
        ActionState,
        Counter,
        CounterCreateBloc,
        CounterFormBloc,
        CounterFormData,
        CounterGetBloc,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        LayoutTierBloc,
        LayoutTierState;
import 'package:game_oclock/models/models.dart' show LayoutTier;

class CreateForm extends StatelessWidget {
  const CreateForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => CounterFormBloc(
                formGroup: CounterFormData(
                  name: TextEditingController(),
                  data: TextEditingController(),
                ),
              ),
        ),
        BlocProvider(create: (_) => CounterCreateBloc()),
      ],
      child: const CreateEditForm(title: 'Creating', create: true),
    );
  }
}

class CreateEditForm extends StatelessWidget {
  const CreateEditForm({super.key, required this.title, required this.create});

  final bool create;
  final String title;

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
      context.read<CounterGetBloc>().add(ActionStarted(data: 'get'));
      /*return MultiBlocListener(
        listeners: [
          BlocListener<FormBloc, FormState2>(
            listener: (final context, final state) {
              print('This form is a $state');
              if (state is FormStateSubmitSuccess) {
                context.read<CounterCreateBloc>().add(
                  ActionStarted(
                    data: Counter(
                      name: state.data['name'],
                      data: state.data['data'],
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<CounterCreateBloc, ActionState<void>>(
            listener: (final context, final state) {
              final snackBar = SnackBar(content: Text('Data created $state'));
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<CounterGetBloc, ActionState<Counter>>(
              builder: (final context, final getState) {
                Counter? counter;
                bool skeleton = false;
                if (getState is ActionFinal<Counter>) {
                  counter = getState.data;
                }
                if (getState is ActionInProgress<Counter>) {
                  skeleton = true;
                  counter = getState.data;
                }

                nameController.value = nameController.value.copyWith(
                  text: counter?.name,
                );
                dataController.value = dataController.value.copyWith(
                  text: counter == null ? null : '${counter.data}',
                );

                return BlocBuilder<FormBloc, FormState2>(
                  builder: (final context, final formState) {
                    final readOnly = formState is FormStateSubmitInProgress;
                    return Form(
                      key: formState.key,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: nameController,
                            readOnly: readOnly,
                            onSaved:
                                formState.group
                                    .getControl<String>('name')
                                    .onSave,
                            // The validator receives the text that the user has entered.
                            validator: (final value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: dataController,
                            readOnly: readOnly,
                            onSaved:
                                (final newValue) => formState.group
                                    .getControl<int>('data')
                                    .onSave(
                                      newValue == null
                                          ? null
                                          : int.tryParse(newValue),
                                    ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );*/
      return const Center();
    }
  }

  Widget buildCreateForm(
    final BuildContext context, {
    required final bool fullscreen,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CounterFormBloc, FormState2<CounterFormData, Counter>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<CounterFormData, Counter>) {
              context.read<CounterCreateBloc>().add(
                ActionStarted(data: state.data),
              );
            }
          },
        ),
        BlocListener<CounterCreateBloc, ActionState<void>>(
          listener: (final context, final state) {
            final snackBar = SnackBar(content: Text('Data created $state'));
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ],
      child: BlocBuilder<CounterFormBloc, FormState2<CounterFormData, Counter>>(
        builder: (final context, final formState) {
          return BlocBuilder<CounterCreateBloc, ActionState<void>>(
            builder: (final context, final createState) {
              final loading =
                  formState is FormStateSubmitInProgress ||
                  createState is ActionInProgress;

              return FullForm(
                title: title,
                formKey: formState.key,
                fullscreen: fullscreen,
                onClose: () => Navigator.of(context).pop(),
                formFieldsContainer: buildFormFieldsContainer(
                  formGroup: formState.group,
                  readOnly: loading,
                ),
                onSubmit:
                    loading
                        ? null
                        : () {
                          context.read<CounterFormBloc>().add(
                            const FormSubmitted(),
                          );
                        },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildFormFieldsContainer({
    required final CounterFormData formGroup,
    required final bool readOnly,
  }) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: formGroup.name,
          readOnly: readOnly,
          validator: (final value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(controller: formGroup.data, readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
        TextFormField(readOnly: readOnly),
      ],
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
    required this.onClose,
    required this.formFieldsContainer,
    this.onSubmit,
  });

  final String title;
  final Key formKey;
  final bool fullscreen;
  final VoidCallback onClose;
  final Widget formFieldsContainer;
  final VoidCallback? onSubmit;

  @override
  Widget build(final BuildContext context) {
    final saveButton = TextButton.icon(
      icon: onSubmit == null ? const CircularProgressIndicator() : null,
      label: const Text('Save'), // TODO i18n
      onPressed: onSubmit,
    );

    final form = Form(key: formKey, child: formFieldsContainer);

    return fullscreen
        ? Scaffold(
          appBar: AppBar(
            title: Text(title),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close', // TODO i18n
              onPressed: onClose,
            ),
            actions: [saveButton],
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
              OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 16 / 2,
                overflowAlignment: OverflowBarAlignment.end,
                overflowDirection: VerticalDirection.down,
                overflowSpacing: 0,
                children: [
                  TextButton(
                    onPressed: onClose,
                    child: const Text('Cancel'), // TODO i18n
                  ),
                  saveButton,
                ],
              ),
            ],
          ),
        );
  }
}
