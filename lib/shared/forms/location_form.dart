import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        LocationCreateBloc,
        LocationFormBloc,
        LocationGetBloc,
        LocationUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart' show Location, LocationFormData;
import 'package:game_oclock/utils/localisation_extension.dart';

class LocationCreateForm extends StatelessWidget {
  const LocationCreateForm({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationFormBloc(
            formGroup: LocationFormData(
              name: TextEditingController(text: initialName),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              LocationCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            Location,
            LocationFormData,
            LocationFormBloc,
            LocationCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

class LocationEditForm extends StatelessWidget {
  const LocationEditForm({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationFormBloc(
            formGroup: LocationFormData(name: TextEditingController()),
          ),
        ),
        BlocProvider(
          create: (_) =>
              LocationUpdateBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              LocationGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            Location,
            LocationFormData,
            LocationFormBloc,
            LocationGetBloc,
            LocationUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final LocationFormData formGroup,
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
