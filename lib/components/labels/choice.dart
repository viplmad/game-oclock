import 'package:flutter/material.dart';
import 'package:game_oclock/components/label_chip.dart';
import 'package:game_oclock/models/nav_destination.dart';

class ChoiceLabel extends StatelessWidget {
  const ChoiceLabel({
    super.key,
    required this.label,
    required this.value,
    required this.options,
  });

  final String label;
  final String? value;
  final List<OptionTextField<String>> options;

  @override
  Widget build(final BuildContext context) {
    final option = options.firstWhere(
      (final element) => element.value == value,
      orElse: () => OptionTextField(
        value: value ?? '',
        labelBuilder: (final context) => value ?? '',
      ),
    );

    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : LabelChip(label: option.labelBuilder(context), color: option.color),
    );
  }
}
