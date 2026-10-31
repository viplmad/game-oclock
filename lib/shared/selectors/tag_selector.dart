import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show TagGetBloc, TagListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/tag_list_item.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TagSelectorBuilder extends StatelessWidget {
  const TagSelectorBuilder({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<String> formControl;
  final String label;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return SingleAutocompleteSelectorBuilder<TagDTO, TagGetBloc, TagListBloc>(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (context, item, index, onSelected) =>
          TagTileListItem(data: item, onTap: onSelected),
      keyGetter: (item) => item.id,
      displayString: (item) => item.name,
      onAddPressed: (quicksearch, onSelected) async =>
          showReturningDialog<String>(
            context,
            builder: (context) => TagCreateForm(initialName: quicksearch),
            onSuccess: (context, data) => onSelected(data),
          ),
    );
  }
}
