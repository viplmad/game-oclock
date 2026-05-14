import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/components/list/sticky_list.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/constants.dart';

import 'text.dart';

class TileListSkeleton extends StatelessWidget {
  const TileListSkeleton({
    super.key,
    required this.itemBuilder,
    this.borderRadius,
  });

  final Widget Function(int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final availableHeight = constraints.maxHeight;

        final itemHeight = kTileImageMinHeight;

        final itemCount = (availableHeight / itemHeight).ceil();

        return TileList(
          items: List.filled(itemCount, 0, growable: false),
          itemBuilder: (_, _, final index) => itemBuilder(index),
          borderRadius: borderRadius,
        );
      },
    );
  }
}

class GridListSkeleton extends StatelessWidget {
  const GridListSkeleton({
    super.key,
    required this.itemBuilder,
    this.borderRadius,
    required this.itemAspectRatio,
    required this.columns,
  });

  final Widget Function(int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;
  final double itemAspectRatio;
  final int columns;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final itemWidth = availableWidth / columns;

        final itemHeight = itemWidth / itemAspectRatio;

        final minRows = (availableHeight / itemHeight).ceil();

        final itemCount = minRows * columns;

        return GridList(
          items: List.filled(itemCount, 0, growable: false),
          itemBuilder: (_, _, final index) {
            final column = index % columns;
            final row = (index / columns).floor();
            return itemBuilder(column + row);
          },
          borderRadius: borderRadius,
          itemAspectRatio: itemAspectRatio,
          columns: columns,
        );
      },
    );
  }
}

class CenteredGridListSkeleton extends StatelessWidget {
  const CenteredGridListSkeleton({
    super.key,
    required this.itemBuilder,
    this.borderRadius,
    required this.itemAspectRatio,
    required this.columns,
    required this.itemCount,
  });

  final Widget Function(int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;
  final double itemAspectRatio;
  final int columns;
  final int itemCount;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        return CenteredGridList(
          items: List.filled(itemCount, 0, growable: false),
          itemBuilder: (_, _, final index) {
            final column = index % columns;
            final row = (index / columns).floor();
            return itemBuilder(column + row);
          },
          borderRadius: borderRadius,
          itemAspectRatio: itemAspectRatio,
          columns: columns,
        );
      },
    );
  }
}

class StickySideHeaderListSkeleton extends StatelessWidget {
  const StickySideHeaderListSkeleton({
    super.key,
    required this.headerBuilder,
    required this.itemBuilder,
    this.borderRadius,
  });

  final Widget Function() headerBuilder;
  final Widget Function(int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    return StickySideHeaderList(
      items: List.filled(3, 0, growable: false).fold(
        <int, List<int>>{},
        (final prev, final el) =>
            prev..[el] = List.filled(3, 0, growable: false),
      ),
      headerBuilder: (_) => headerBuilder(),
      itemBuilder: (_, _, final index) => itemBuilder(index),
      borderRadius: borderRadius,
    );
  }
}

class StickyTopHeaderListSkeleton extends StatelessWidget {
  const StickyTopHeaderListSkeleton({
    super.key,
    required this.headerBuilder,
    required this.itemBuilder,
    this.borderRadius,
  });

  final Widget Function() headerBuilder;
  final Widget Function(int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    return StickyTopHeaderList(
      items: List.filled(3, 0, growable: false).fold(
        <int, List<int>>{},
        (final prev, final el) =>
            prev..[el] = List.filled(3, 0, growable: false),
      ),
      headerBuilder: (_) => headerBuilder(),
      itemBuilder: (_, _, final index) => itemBuilder(index),
      borderRadius: borderRadius,
    );
  }
}

class ListFilterToolbarSkeleton extends StatelessWidget {
  const ListFilterToolbarSkeleton({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: TextSkeleton(width: 100.0, height: 14.0, order: order + 0),
    );
  }
}

class ListTotalStatusbarSkeleton extends StatelessWidget {
  const ListTotalStatusbarSkeleton({super.key, this.order = 0});

  final int order;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: kStatusbarHeight,
      child: TextSkeleton(width: 50.0, height: 14.0, order: order),
    );
  }
}
