import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show DeviceGetBloc, DeviceListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Device;
import 'package:game_oclock/shared/forms/device_form.dart';
import 'package:game_oclock/shared/list_item/device_list_item.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DeviceSelectorBuilder extends StatelessWidget {
  const DeviceSelectorBuilder({
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
      Device,
      DeviceGetBloc,
      DeviceListBloc
    >(
      formControl: formControl,
      label: label,
      readOnly: readOnly,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          DeviceTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      onAddPressed: (final quicksearch, final onSelected) async =>
          showFormDialog<Device>(
            context,
            builder: (final context) =>
                DeviceCreateForm(initialName: quicksearch),
            onSuccess: (final context, final data) => onSelected(data),
          ),
    );
  }
}
