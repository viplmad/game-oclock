import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show DeviceCreateBloc, DeviceListBloc;
import 'package:game_oclock/components/single_autocomplete_selector.dart';
import 'package:game_oclock/models/models.dart' show Device;
import 'package:game_oclock/shared/list_item/device_list_item.dart';

class DeviceSelectorBuilder extends StatelessWidget {
  const DeviceSelectorBuilder({
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
    return SingleAutocompleteSelectorBuilder<Device, DeviceListBloc>(
      controller: controller,
      label: label,
      required: required,
      readOnly: readOnly,
      validator: validator,
      itemBuilder: (final context, final item, final index, final onSelected) =>
          DeviceTileListItem(data: item, onTap: onSelected),
      keyGetter: (final item) => item.id,
      displayString: (final item) => item.name,
      newConfig: AutocompleteNewConfig<Device, DeviceCreateBloc>(
        newBuilder: (final quicksearch) => Device(id: '', name: quicksearch),
      ),
    );
  }
}
