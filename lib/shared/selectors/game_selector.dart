import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show UserGameCreateBloc, UserGameListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show UserGame;
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';

class UserGameSelectorBuilder extends StatelessWidget {
  const UserGameSelectorBuilder({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(final BuildContext context) {
    return SingleAutocompleteSelectorBuilder<UserGame, UserGameListBloc>(
      controller: controller,
      label: label,
      required: required,
      readOnly: readOnly,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          UserGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.title,
      newConfig: AutocompleteNewConfig<UserGame, UserGameCreateBloc>(
        newBuilder: (final quicksearch) => UserGame(
          id: '',
          title: quicksearch,
          externalIds: [],
          edition: '',
          releaseDate: null,
          genres: [],
          series: [],
          coverUrl: '',
          status: '',
          rating: 0,
          notes: '',
        ),
      ),
    );
  }
}
