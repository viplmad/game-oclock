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
import 'package:game_oclock/models/models.dart' show LocationFormData;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LocationCreateForm extends StatelessWidget {
  const LocationCreateForm({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationFormBloc(
            data: LocationFormData(
              name: FormControl<String>(
                value: initialName,
                validators: [NotEmptyValidator(context)],
              ),
              imageUrl: FormControl<String>(),
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
            NewLocationDTO,
            LocationDTO,
            String,
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationFormBloc(
            data: LocationFormData(
              name: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              imageUrl: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => LocationUpdateBloc(
            service: RepositoryProvider.of(context),
            id: id,
          ),
        ),
        BlocProvider(
          create: (_) =>
              LocationGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
      ],
      child:
          EditFormBuilder<
            NewLocationDTO,
            LocationDTO,
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
  BuildContext context,
  LocationFormData formGroup,
  bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.name,
        label: context.localize().nameLabel,
        readOnly: readOnly,
      ),
      SimpleTextFormField(
        formControl: formGroup.imageUrl,
        label: context.localize().imageUrlLabel,
        readOnly: readOnly,
      ),
    ],
  );
}
