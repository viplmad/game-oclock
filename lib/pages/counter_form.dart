import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        Counter,
        CounterCreateBloc,
        CounterFormBloc,
        CounterFormData,
        CounterGetBloc,
        CounterUpdateBloc;
import 'package:game_oclock/components/create_edit_form.dart';

class CounterCreateForm extends StatelessWidget {
  const CounterCreateForm({super.key});

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
      child: const CreateEditFormBuilder<
        Counter,
        CounterFormData,
        CounterFormBloc,
        CounterGetBloc,
        CounterCreateBloc,
        CounterUpdateBloc
      >(title: 'Creating', create: true, fieldsBuilder: _fieldsBuilder),
    );
  }
}

class CounterEditForm extends StatelessWidget {
  const CounterEditForm({super.key});

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
        BlocProvider(create: (_) => CounterUpdateBloc()),
        BlocProvider(
          create: (_) => CounterGetBloc()..add(ActionStarted(data: 'get')),
        ),
      ],
      child: const CreateEditFormBuilder<
        Counter,
        CounterFormData,
        CounterFormBloc,
        CounterGetBloc,
        CounterCreateBloc,
        CounterUpdateBloc
      >(title: 'Editing', create: false, fieldsBuilder: _fieldsBuilder),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final CounterFormData formGroup,
  final bool readOnly,
) {
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
