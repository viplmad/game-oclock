import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ExternalGameListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame;
import 'package:game_oclock/shared/list_item/external_game_list_item.dart';

class ExternalGameSelectorBuilder extends StatelessWidget {
  const ExternalGameSelectorBuilder({
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
    return SingleAutocompleteSelectorBuilder<
      ExternalGame,
      ExternalGameListBloc
    >(
      controller: controller,
      label: label,
      required: required,
      readOnly: readOnly,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          ExternalGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.title,
    );
  }
}
