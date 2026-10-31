import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  const TextLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final Widget icon;
  final String label;
  final String? value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        value ?? '-',
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: multiline ? null : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class MultipleTextLabel extends StatelessWidget {
  const MultipleTextLabel({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  final Widget icon;
  final String label;
  final List<String>? value;
  final separator = ',';

  @override
  Widget build(BuildContext context) {
    return TextLabel(
      icon: icon,
      label: label,
      value: value == null || value!.isEmpty
          ? null
          : value!.join('$separator '),
    );
  }
}
