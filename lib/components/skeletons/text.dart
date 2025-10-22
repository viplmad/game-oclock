import 'package:flutter/material.dart';

import 'common.dart';

class TextSkeleton extends StatelessWidget {
  const TextSkeleton({super.key, this.width, this.height, this.order = 0});

  final double? width;
  final double? height;
  final int order;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [RoundSkeleton(width: width, height: height, order: order)],
    );
  }
}
