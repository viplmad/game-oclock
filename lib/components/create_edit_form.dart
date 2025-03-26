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

          final scaffold = buildCreateScaffold(context, fullscreen);
          return fullscreen
              ? Dialog.fullscreen(child: scaffold)
              : Dialog(child: scaffold);
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

  Widget buildCreateScaffold(
    final BuildContext context,
    final bool fullscreen,
  ) {
    final saveButton =
        BlocBuilder<CounterFormBloc, FormState2<CounterFormData, Counter>>(
          builder: (final context, final formState) {
            return BlocBuilder<CounterCreateBloc, ActionState<void>>(
              builder: (final context, final createState) {
                final loading =
                    formState is FormStateSubmitInProgress ||
                    createState is ActionInProgress;
                return TextButton.icon(
                  icon: loading ? const CircularProgressIndicator() : null,
                  label: const Text('Save'),
                  onPressed:
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
        );

    return Scaffold(
      appBar: buildAppBar(context, fullscreen, saveButton),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CounterFormBloc, FormState2<CounterFormData, Counter>>(
            listener: (final context, final state) {
              print('This form is a $state');
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
        child:
            BlocBuilder<CounterFormBloc, FormState2<CounterFormData, Counter>>(
              builder: (final context, final formState) {
                return BlocBuilder<CounterCreateBloc, ActionState<void>>(
                  builder: (final context, final createState) {
                    final readOnly =
                        formState is FormStateSubmitInProgress ||
                        createState is ActionInProgress;
                    final form = buildForm(formState, readOnly);

                    return fullscreen
                        ? form
                        : Column(
                          children: [
                            Flexible(child: form),
                            OverflowBar(
                              alignment: MainAxisAlignment.end,
                              spacing: 16 / 2,
                              overflowAlignment: OverflowBarAlignment.end,
                              overflowDirection: VerticalDirection.down,
                              overflowSpacing: 0,
                              children: [saveButton],
                            ),
                          ],
                        );
                  },
                );
              },
            ),
      ),
    );
  }

  AppBar buildAppBar(
    final BuildContext context,
    final bool fullscreen,
    final Widget saveButton,
  ) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading:
          fullscreen
              ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      actions: fullscreen ? [saveButton] : null,
    );
  }

  Form buildForm(
    final FormState2<CounterFormData, Counter> formState,
    final bool readOnly,
  ) {
    return Form(
      key: formState.key,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: formState.group.name,
            readOnly: readOnly,
            validator: (final value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(controller: formState.group.data, readOnly: readOnly),
        ],
      ),
    );
  }
}
