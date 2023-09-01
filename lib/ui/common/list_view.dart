import 'package:flutter/material.dart';

import 'package:game_collection/ui/utils/shape_utils.dart';

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
          padding: const EdgeInsets.only(
            right: 4.0,
            left: 4.0,
            bottom: 4.0,
            top: 4.0,
          ),
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
          padding: const EdgeInsets.only(
            right: 4.0,
            left: 4.0,
            bottom: 4.0,
            top: 4.0,
          ),
          child: ShapeUtils.forceCardRound(
            itemBuilder(context, index),
          ),
        );
      },
    );
  }
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
