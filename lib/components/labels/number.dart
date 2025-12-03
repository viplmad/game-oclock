import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';

class RatingLabel extends StatelessWidget {
  const RatingLabel({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final int? value;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonIcons.colorStar(color),
                Text(
                  value!.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
    );
  }
}
