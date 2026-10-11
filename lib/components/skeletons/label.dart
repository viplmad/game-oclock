import 'package:flutter/material.dart';

import 'text.dart';

class LabelSkeleton extends StatelessWidget {
  const LabelSkeleton({super.key, this.order = 0, this.icon, this.label});

  final int order;
  final Widget? icon;
  final String? label;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: icon,
      title: label == null
          ? TextSkeleton(width: 50.0, height: 14.0, order: order + 0)
          : Text(label!, style: Theme.of(context).textTheme.titleSmall),
      subtitle: TextSkeleton(
        width: 200.0,
        height: 16.0,
        order: order + (label == null ? 1 : 0),
      ),
    );
  }
}
