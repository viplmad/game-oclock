import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ExternalGameListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame;
import 'package:game_oclock/shared/list_item/external_game_list_item.dart';

class ExternalGameSelectorBuilder extends StatelessWidget {
  const ExternalGameSelectorBuilder({
    super.key,
    required this.controller,
    this.validator,
    this.decoration,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;

  @override
  Widget build(final BuildContext context) {
    return SingleAutocompleteSelectorBuilder<
      ExternalGame,
      ExternalGameListBloc
    >(
      controller: controller,
      decoration: decoration,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          ExternalGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.title,
      mockItem: ExternalGame(
        externalSource: '',
        externalId: '',
        title: '',
        coverUrl: '',
        releaseDate: DateTime.now(),
      ),
    );
  }
}
