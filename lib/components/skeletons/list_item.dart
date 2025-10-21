import 'package:flutter/material.dart';
import 'package:game_oclock/components/skeletons/common.dart';
import 'package:game_oclock/constants/constants.dart';

import 'tile.dart';

class TileListSkeletonItem extends StatelessWidget {
  const TileListSkeletonItem({
    super.key,
    this.order = 0,
    this.hasImage = false,
  });

  final int order;
  final bool hasImage;

  @override
  Widget build(final BuildContext context) {
    return ListTileSkeleton(order: order, leading: hasImage);
  }
}

class GridListSkeletonItem extends StatelessWidget {
  const GridListSkeletonItem({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return GridTileSkeleton(order: order);
  }
}

class SideHeaderSkeletonItem extends StatelessWidget {
  const SideHeaderSkeletonItem({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: kAvatarWidth,
          height: kAvatarHeight,
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            child: RoundSkeleton(width: 20.0, height: 16.0, order: order + 1),
          ),
        ),
      ),
    );
  }
}
