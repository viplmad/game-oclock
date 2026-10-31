import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({super.key, required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class BoolLabel extends StatelessWidget {
  const BoolLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : value!
          ? CommonIcons.yes
          : CommonIcons.no,
    );
  }
}
