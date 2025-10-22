import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.title,
    this.image,
    required this.onBackPressed,
    required this.child,
    this.actions,
  });

  final Widget title;
  final Widget? image;
  final VoidCallback onBackPressed;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: _appBarBuilder, body: child),
    );
  }

  List<Widget> _appBarBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
  ) {
    return <Widget>[
      SliverAppBar(
        expandedHeight:
            MediaQuery.of(context).size.height /
            3, //Third part of height of screen
        surfaceTintColor: Theme.of(context).primaryColor,
        // Fixed elevation so background colour doesn't change on scroll
        forceElevated: true,
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
        floating: false,
        pinned: true,
        snap: false,
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: onBackPressed),
        actions: actions,
        bottom: const PreferredSize(
          preferredSize: Size(double.maxFinite, 1.0),
          child: SizedBox(),
        ),
        flexibleSpace: FlexibleSpaceBar(
          title: title,
          collapseMode: CollapseMode.parallax,
          background: image ?? const SizedBox(),
        ),
      ),
    ];
  }
}
