import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/shape_utils.dart';

import 'header_text.dart';
import 'skeleton.dart';

class ItemListBuilder extends StatelessWidget {
  const ItemListBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.canBeDragged = false,
    this.padding,
  }) : super(key: key);

  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final ScrollController? controller;
  final bool canBeDragged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: canBeDragged ? const ClampingScrollPhysics() : null,
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ShapeUtils.forceCardRound(
            itemBuilder(context, index),
          ),
        );
      },
    );
  }
}

class ItemGridBuilder extends StatelessWidget {
  const ItemGridBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.canBeDragged = false,
    this.padding,
  }) : super(key: key);

  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final ScrollController? controller;
  final bool canBeDragged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: canBeDragged ? const ClampingScrollPhysics() : null,
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 200).ceil(),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ShapeUtils.forceCardRound(
            itemBuilder(context, index),
          ),
        );
      },
    );
  }
}

class ItemSliverCardSectionBuilder extends StatelessWidget {
  const ItemSliverCardSectionBuilder({
    Key? key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _ItemSliverHeaderDelegate(title),
        ),
        SliverList.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ShapeUtils.forceCardRound(
                itemBuilder(context, index),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ItemSliverGridSectionBuilder extends StatelessWidget {
  const ItemSliverGridSectionBuilder({
    Key? key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _ItemSliverHeaderDelegate(title),
        ),
        SliverGrid.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 200).ceil(),
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ShapeUtils.forceCardRound(
                itemBuilder(context, index),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ItemSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ItemSliverHeaderDelegate(this.title);

  final String title;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.grey,
      child: HeaderText(
        text: title,
      ),
    );
  }

  @override
  double get maxExtent => minExtent;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class SkeletonItemList extends StatelessWidget {
  const SkeletonItemList({
    Key? key,
    this.single = false,
    this.canBeDragged = false,
    required this.itemHasImage,
    this.padding,
  }) : super(key: key);

  final bool single;
  final bool canBeDragged;
  final bool itemHasImage;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ItemListBuilder(
      canBeDragged: canBeDragged,
      padding: padding,
      itemCount: single ? 1 : 3,
      itemBuilder: (BuildContext context, int index) {
        return SkeletonItemCard(
          hasImage: itemHasImage,
          order: index,
        );
      },
    );
  }
}
