import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';

class BoolLabel extends StatelessWidget {
  const BoolLabel({super.key, required this.label, required this.value});

  final String label;
  final bool? value;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : value!
          ? CommonIcons.yes
          : CommonIcons.no,
    );
  }
}
