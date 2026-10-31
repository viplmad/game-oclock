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
  Widget build(BuildContext context) {
    return SingleAutocompleteSelectorBuilder<
      MediaDTO,
      UserGameGetBloc,
      UserGameListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (context, item, index, onSelected) =>
          UserGameTileListItem(data: item, onTap: onSelected),
      keyGetter: (item) => item.media.id,
      displayString: (item) => item.media.title,
      onAddPressed: (quicksearch, onSelected) async =>
          showReturningDialog<String>(
            context,
            builder: (context) => UserGameCreateForm(initialTitle: quicksearch),
            onSuccess: (context, data) => onSelected(data),
          ),
    );
  }
}
