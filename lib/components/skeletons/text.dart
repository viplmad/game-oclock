import 'package:flutter/material.dart';

import 'skeleton.dart';

const double _kTitleTextWidth = 200;
const double _kTitleTextHeight = 16.0;

const double _kSubtitleTextWidth = 100;
const double _kSubtitleTextHeight = 14.0;

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key, this.subtitle = false});

  final bool subtitle;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoundSkeleton(
            width: _kTitleTextWidth,
            height: _kTitleTextHeight,
            order: 0,
          ),
        ],
      ),
      subtitle: subtitle
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RoundSkeleton(
                  width: _kSubtitleTextWidth,
                  height: _kSubtitleTextHeight,
                  order: 1,
                ),
              ],
            )
          : null,
    );
  }
}
