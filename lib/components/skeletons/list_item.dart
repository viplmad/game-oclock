import 'package:flutter/material.dart';
import 'package:game_oclock/components/skeletons/common.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/constants.dart';

import 'text.dart';

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
    return ListTile(
      leading: hasImage
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: kTileImageMinWidth,
                minHeight: kTileImageMinHeight,
                maxWidth: kTileImageMinWidth,
                maxHeight: kTileImageMinHeight,
              ),
              child: Skeleton(order: order + 0),
            )
          : null,
      title: TextSkeleton(width: 100.0, height: 14.0, order: order + 1),
    );
  }
}

class GridListSkeletonItem extends StatelessWidget {
  const GridListSkeletonItem({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return GridTile(child: Skeleton(order: order));
  }
}

class CenteredGridListSkeletonItem extends StatelessWidget {
  const CenteredGridListSkeletonItem({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return Skeleton(order: order);
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
            backgroundColor: CommonColors.darkerGrey,
            foregroundColor: CommonColors.white,
            child: RoundSkeleton(width: 20.0, height: 16.0, order: order),
          ),
        ),
      ),
    );
  }
}
