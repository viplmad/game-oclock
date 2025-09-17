import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show TagListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Tag;
import 'package:game_oclock/shared/list_item/tag_list_item.dart';

class TagSelectorBuilder extends StatelessWidget {
  const TagSelectorBuilder({
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
    return SingleAutocompleteSelectorBuilder<Tag, TagListBloc>(
      controller: controller,
      decoration: decoration,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          TagTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      mockItem: const Tag(id: '', name: ''),
    );
  }
}
