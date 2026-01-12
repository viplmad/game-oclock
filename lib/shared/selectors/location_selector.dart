import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show LocationGetBloc, LocationListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Location;
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/list_item/location_list_item.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LocationSelectorBuilder extends StatelessWidget {
  const LocationSelectorBuilder({
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
      Location,
      LocationGetBloc,
      LocationListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          LocationTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      onAddPressed: (final quicksearch, final onSelected) async =>
          showFormDialog<Location>(
            context,
            builder: (final context) =>
                LocationCreateForm(initialName: quicksearch),
            onSuccess: (final context, final data) => onSelected(data),
          ),
    );
  }
}
