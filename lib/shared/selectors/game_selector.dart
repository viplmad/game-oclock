import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show UserGameGetBloc, UserGameListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UserGameSelectorBuilder extends StatelessWidget {
  const UserGameSelectorBuilder({
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
      MediaDTO,
      UserGameGetBloc,
      UserGameListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          UserGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.media.id,
      displayString: (final item) => item.media.title,
      onAddPressed: (final quicksearch, final onSelected) async =>
          showFormDialog<String>(
            context,
            builder: (final context) =>
                UserGameCreateForm(initialTitle: quicksearch),
            onSuccess: (final context, final data) => onSelected(data),
          ),
    );
  }
}
