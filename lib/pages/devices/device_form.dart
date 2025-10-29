import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        DeviceCreateBloc,
        DeviceFormBloc,
        DeviceGetBloc,
        DeviceUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show Device, DeviceFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class DeviceCreateForm extends StatelessWidget {
  const DeviceCreateForm({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeviceFormBloc(
            formGroup: DeviceFormData(
              name: TextEditingController(text: initialName),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              DeviceCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            Device,
            DeviceFormData,
            DeviceFormBloc,
            DeviceCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

class DeviceEditForm extends StatelessWidget {
  const DeviceEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeviceFormBloc(
            formGroup: DeviceFormData(name: TextEditingController()),
          ),
        ),
        BlocProvider(
          create: (_) =>
              DeviceUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              DeviceGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            Device,
            DeviceFormData,
            DeviceFormBloc,
            DeviceGetBloc,
            DeviceUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final DeviceFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.name,
        label: context.localize().nameLabel,
        required: true,
        readOnly: readOnly,
      ),
    ],
  );
}
