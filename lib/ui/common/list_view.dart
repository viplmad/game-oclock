import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock/ui/utils/shape_utils.dart';
import 'package:game_oclock/ui/theme/theme.dart' show AppTheme;

import 'header_text.dart';
import 'skeleton.dart';

const EdgeInsets _listItemPadding = EdgeInsets.all(4.0);

class ItemListBuilder extends StatelessWidget {
  const ItemListBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyTitle = '',
    this.controller,
    this.canBeDragged = false,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String emptyTitle;
  final ScrollController? controller;
  final bool canBeDragged;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyTitle.isNotEmpty) {
      return ListEmpty(
        emptyTitle: emptyTitle,
        canBeDragged: canBeDragged,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: canBeDragged ? const ClampingScrollPhysics() : null,
      controller: controller,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: _listItemPadding,
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
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyTitle = '',
    this.controller,
    this.canBeDragged = false,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String emptyTitle;
  final ScrollController? controller;
  final bool canBeDragged;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyTitle.isNotEmpty) {
      return ListEmpty(
        emptyTitle: emptyTitle,
        canBeDragged: canBeDragged,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: canBeDragged ? const ClampingScrollPhysics() : null,
      controller: controller,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.85, // Steam header aspect ratio
        crossAxisCount: (MediaQuery.of(context).size.width / 400).ceil(),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: _listItemPadding,
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
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

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
              padding: _listItemPadding,
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
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

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
              padding: _listItemPadding,
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
      color: AppTheme.defaultBackgroundColor(context),
      child: ListHeader(
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

class ItemError extends StatelessWidget {
  const ItemError({
    super.key,
    required this.title,
    required this.onRetryTap,
    this.additionalWidgets = const <Widget>[],
  });

  final String title;
  final void Function() onRetryTap;
  final List<Widget> additionalWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(title),
          ),
          ElevatedButton(
            onPressed: onRetryTap,
            style: ElevatedButton.styleFrom(
              surfaceTintColor: AppTheme.defaultThemeSurfaceTintColor(context),
            ),
            child: Text(
              AppLocalizations.of(context)!.retryString,
            ),
          ),
          ...additionalWidgets,
        ],
      ),
    );
  }
}

class ListEmpty extends StatelessWidget {
  const ListEmpty({
    super.key,
    required this.emptyTitle,
    this.canBeDragged = false,
  });

  final String emptyTitle;
  final bool canBeDragged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: canBeDragged ? const ClampingScrollPhysics() : null,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(emptyTitle),
          ),
        ),
      ],
    );
  }
}

class ListDivider extends StatelessWidget {
  const ListDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 4.0);
  }
}

class SkeletonItemList extends StatelessWidget {
  const SkeletonItemList({
    super.key,
    this.single = false,
    this.canBeDragged = false,
    required this.itemHasImage,
  });

  final bool single;
  final bool canBeDragged;
  final bool itemHasImage;

  @override
  Widget build(BuildContext context) {
    return ItemListBuilder(
      canBeDragged: canBeDragged,
      itemCount: single ? 1 : 3,
      emptyTitle: '',
      itemBuilder: (BuildContext context, int index) {
        return SkeletonItemCard(
          hasImage: itemHasImage,
          order: index,
        );
      },
    );
  }
}
