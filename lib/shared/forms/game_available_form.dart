import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameAvailableCreateBloc,
        GameAvailableFormBloc,
        LocationCreateBloc,
        LocationListBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, GameAvailableFormData;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/location_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GameAvailableCreateForm extends StatelessWidget {
  const GameAvailableCreateForm({super.key, this.gameId, this.locationId});

  final String? gameId;
  final String? locationId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameAvailableFormBloc(
            data: GameAvailableFormData(
              gameId: FormControl<String>(
                value: gameId,
                validators: [Validators.required],
              ),
              locationId: FormControl<String>(
                value: locationId,
                validators: [Validators.required],
              ),
              date: FormControl<DateTime>(validators: [Validators.required]),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameAvailableCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              LocationListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              LocationCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            GameAvailable,
            GameAvailableFormData,
            GameAvailableFormBloc,
            GameAvailableCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(
                  context,
                  gameId,
                  locationId,
                  formGroup,
                  readOnly,
                ),
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final String? gameId,
  final String? locationId,
  final GameAvailableFormData formData,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        formControl: formData.gameId,
        label: context.localize().gameLabel,
        readOnly: readOnly || gameId != null,
      ),
      LocationSelectorBuilder(
        formControl: formData.locationId,
        label: context.localize().locationLabel,
        readOnly: readOnly || locationId != null,
      ),
      SimpleDateFormField(
        formControl: formData.date,
        label: context.localize().dateLabel,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
    ],
  );
}
