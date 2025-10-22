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
    return TileList(
      items: List.filled(10, 0, growable: false),
      itemBuilder: (_, _, final index) => itemBuilder(index),
      borderRadius: borderRadius,
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
    return GridList(
      items: List.filled(10, 0, growable: false),
      itemBuilder: (_, _, final index) => itemBuilder(index),
      borderRadius: borderRadius,
      itemAspectRatio: itemAspectRatio,
      columns: columns,
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
