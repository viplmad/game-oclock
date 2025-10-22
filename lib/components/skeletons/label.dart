import 'package:flutter/material.dart';

import 'text.dart';

class LabelSkeleton extends StatelessWidget {
  const LabelSkeleton({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: TextSkeleton(width: 50.0, height: 14.0, order: order + 0),
      subtitle: TextSkeleton(width: 200.0, height: 16.0, order: order + 1),
    );
  }
}
