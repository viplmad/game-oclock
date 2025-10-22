import 'package:flutter/material.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/container.dart';

import 'image.dart';
import 'label.dart';
import 'text.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(final BuildContext context) {
    return Detail(
      title: const AppBarTitleSkeleton(order: 0),
      image: const ImageSkeleton(order: 1),
      onBackPressed: onBackPressed,
      child: const SingleChildScrollView(
        child: LabelsContainer(
          children: [
            LabelSkeleton(order: 2),
            LabelSkeleton(order: 3),
            LabelSkeleton(order: 4),
          ],
        ),
      ),
    );
  }
}

class AppBarTitleSkeleton extends StatelessWidget {
  const AppBarTitleSkeleton({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return TextSkeleton(width: 50.0, height: 14.0, order: order);
  }
}
