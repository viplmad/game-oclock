import 'package:flutter/material.dart';

import 'common.dart';

class ImageSkeleton extends StatelessWidget {
  const ImageSkeleton({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return Skeleton(order: order);
  }
}
