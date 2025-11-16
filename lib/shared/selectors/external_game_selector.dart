import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ExternalGameListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame;
import 'package:game_oclock/shared/list_item/external_game_list_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ExternalGameSelectorBuilder extends StatelessWidget {
  const ExternalGameSelectorBuilder({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<String> formControl;
  final String label;
  final bool readOnly;

  @override
  Widget build(final BuildContext context) {
    return SingleAutocompleteSelectorBuilder<
      ExternalGame,
      ExternalGameListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          ExternalGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.title,
    );
  }
}
