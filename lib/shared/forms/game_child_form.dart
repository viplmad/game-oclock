import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        GameChildCreateBloc,
        GameChildFormBloc,
        UserGameCreateBloc,
        UserGameGetBloc,
        UserGameListBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/models/models.dart'
    show GameChild, GameChildFormData;
import 'package:game_oclock/shared/selectors/game_selector.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GameChildCreateForm extends StatelessWidget {
  const GameChildCreateForm({super.key, this.parentGameId, this.childGameId});

  final String? parentGameId;
  final String? childGameId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameChildFormBloc(
            data: GameChildFormData(
              parentGameId: FormControl<String>(
                value: parentGameId,
                validators: [NotEmptyValidator(context)],
              ),
              childGameId: FormControl<String>(
                value: childGameId,
                validators: [NotEmptyValidator(context)],
              ),
              order: FormControl<String>(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) =>
              GameChildCreateBloc(service: RepositoryProvider.of(context)),
        ),

        BlocProvider(
          create: (_) =>
              UserGameGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameCreateBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child:
          CreateFormBuilder<
            GameChild,
            GameChild,
            (String, String, int?),
            GameChildFormData,
            GameChildFormBloc,
            GameChildCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: (final context, final formGroup, final readOnly) =>
                _fieldsCreateBuilder(
                  context,
                  parentGameId,
                  childGameId,
                  formGroup,
                  readOnly,
                ),
          ),
    );
  }
}

Widget _fieldsCreateBuilder(
  final BuildContext context,
  final String? parentGameId,
  final String? childGameId,
  final GameChildFormData formData,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      UserGameSelectorBuilder(
        formControl: formData.parentGameId,
        label: context.localize().parentGameLabel,
        readOnly: readOnly || parentGameId != null,
      ),
      UserGameSelectorBuilder(
        formControl: formData.childGameId,
        label: context.localize().childGameLabel,
        readOnly: readOnly || childGameId != null,
      ),
      SimpleTextFormField(
        formControl: formData.order,
        label: context.localize().orderLabel,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
      ),
    ],
  );
}
