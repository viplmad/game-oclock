import 'package:flutter/material.dart';
import 'package:game_oclock/constants/constants.dart';

import 'common.dart';

const double _kTitleTextWidth = 200;
const double _kTitleTextHeight = 16.0;

const double _kSubtitleTextWidth = 100;
const double _kSubtitleTextHeight = 14.0;

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({
    super.key,
    this.order = 0,
    this.leading = false,
    this.subtitle = false,
  });

  final int order;
  final bool leading;
  final bool subtitle;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: leading
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: kTileImageMinWidth,
                minHeight: kTileImageMinHeight,
                maxWidth: kTileImageMinWidth,
                maxHeight: kTileImageMinHeight,
              ),
              child: Skeleton(order: order + 1),
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoundSkeleton(
            width: _kTitleTextWidth,
            height: _kTitleTextHeight,
            order: order + 0,
          ),
        ],
      ),
      subtitle: subtitle
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RoundSkeleton(
                  width: _kSubtitleTextWidth,
                  height: _kSubtitleTextHeight,
                  order: order + 1,
                ),
              ],
            )
          : null,
    );
  }
}

class GridTileSkeleton extends StatelessWidget {
  const GridTileSkeleton({super.key, required this.order});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return GridTile(child: Skeleton(order: order));
  }
}
