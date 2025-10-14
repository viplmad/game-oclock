import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show GamePlaythroughCreateBloc, GamePlaythroughListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show GamePlaythrough;
import 'package:game_oclock/shared/list_item/game_playthrough_list_item.dart';

class GamePlaythroughSelectorBuilder extends StatelessWidget {
  const GamePlaythroughSelectorBuilder({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
    required this.gameId,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final String gameId;

  @override
  Widget build(final BuildContext context) {
    return SingleAutocompleteSelectorBuilder<
      GamePlaythrough,
      GamePlaythroughListBloc
    >(
      controller: controller,
      label: label,
      required: required,
      readOnly: readOnly,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          GamePlaythroughTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      newConfig:
          AutocompleteNewConfig<GamePlaythrough, GamePlaythroughCreateBloc>(
            newBuilder: (final quicksearch) =>
                GamePlaythrough(id: '', gameId: gameId, name: quicksearch),
          ),
    );
  }
}
