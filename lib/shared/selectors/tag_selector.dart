import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show TagListBloc;
import 'package:game_oclock/components/show_form_dialog.dart';
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Tag;
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/tag_list_item.dart';

class TagSelectorBuilder extends StatelessWidget {
  const TagSelectorBuilder({
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
    return SingleAutocompleteSelectorBuilder<Tag, TagListBloc>(
      controller: controller,
      label: label,
      required: required,
      readOnly: readOnly,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          TagTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      onAddPressed: (final quicksearch, final onSelected) async =>
          showFormDialog<Tag>(
            context,
            builder: (final context) => TagCreateForm(initialName: quicksearch),
            onSuccess: (final context, final data) => onSelected(data),
          ),
    );
  }
}
