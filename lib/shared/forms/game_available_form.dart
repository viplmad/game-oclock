import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameAvailableCreateBloc,
        GameAvailableFormBloc,
        ListLoaded,
        LocationCreateBloc,
        LocationListBloc,
        UserGameCreateBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, GameAvailableFormData, ListSearch, SearchDTO;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/shared/selectors/location_selector.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

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
            formGroup: GameAvailableFormData(
              gameId: TextEditingController(text: gameId),
              locationId: TextEditingController(text: locationId),
              date: DateTimeEditingController(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameAvailableCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context))..add(
                // Requires search to be loaded
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              LocationListBloc(service: RepositoryProvider.of(context))..add(
                // Requires search to be loaded
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
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
  final GameAvailableFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        controller: formGroup.gameId,
        label: context.localize().gameLabel,
        required: true,
        readOnly: readOnly || gameId != null,
      ),
      LocationSelectorBuilder(
        controller: formGroup.locationId,
        label: context.localize().locationLabel,
        required: true,
        readOnly: readOnly || locationId != null,
      ),
      SimpleDateFormField(
        controller: formGroup.date,
        label: context.localize().dateLabel,
        required: true,
        readOnly: readOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      ),
    ],
  );
}
