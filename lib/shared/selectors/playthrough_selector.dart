import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show PlaythroughGetBloc, PlaythroughListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Playthrough;
import 'package:game_oclock/shared/forms/playthrough_form.dart';
import 'package:game_oclock/shared/list_item/playthrough_list_item.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PlaythroughSelectorBuilder extends StatelessWidget {
  const PlaythroughSelectorBuilder({
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
      Playthrough,
      PlaythroughGetBloc,
      PlaythroughListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          PlaythroughTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      onAddPressed: (final quicksearch, final onSelected) async =>
          showReturningDialog<String>(
            context,
            builder: (final context) =>
                PlaythroughCreateForm(initialName: quicksearch),
            onSuccess: (final context, final data) => onSelected(data),
          ),
    );
  }
}
