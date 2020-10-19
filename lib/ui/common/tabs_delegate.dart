import 'package:flutter/material.dart';


class TabsDelegate extends SliverPersistentHeaderDelegate {
  const TabsDelegate({
    @required this.tabBar,
    this.color,
  }) : super();

  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: color?? Theme.of(context).primaryColor,
      child: tabBar,
    );

  }

  @override
  bool shouldRebuild(TabsDelegate oldDelegate) {
    return false;
  }
}