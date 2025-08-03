import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onBackPressed,
    required this.onEditPressed,
    required this.content,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onBackPressed;
  final VoidCallback onEditPressed;
  final Widget content;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: _appBarBuilder,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
          child: content,
        ),
      ),
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
        actions: [
          IconButton(
            icon: const Icon(CommonIcons.edit),
            tooltip: 'Edit',
            onPressed: onEditPressed,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size(double.maxFinite, 1.0),
          child: SizedBox(),
        ),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(title),
          collapseMode: CollapseMode.parallax,
          background:
              imageUrl.isEmpty
                  ? const SizedBox()
                  : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    useOldImageOnUrlChange: true,
                    progressIndicatorBuilder:
                        (_, __, ___) =>
                            const CircularProgressIndicator(), // TODO skeleton
                    errorWidget: (_, __, ___) => Container(color: Colors.grey),
                  ),
        ),
      ),
    ];
  }
}
