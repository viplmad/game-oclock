import 'package:flutter/material.dart';
import 'package:game_oclock/components/search_text_field.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

const kToolbarLeadingPadding = 72.0;

class SimpleSliverAppBar extends StatelessWidget {
  const SimpleSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.titlePadding,
  });

  final Widget title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? titlePadding;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);
    final hasLeading = layoutTier == LayoutTier.compact;

    return SliverAppBar(
      surfaceTintColor: Theme.of(context).primaryColor,
      // Fixed elevation so background colour doesn't change on scroll
      forceElevated: true,
      elevation: 1.0,
      scrolledUnderElevation: 1.0,
      floating: true,
      pinned: false,
      snap: false,
      automaticallyImplyLeading: false,
      leading: hasLeading
          ? IconButton(
              icon: CommonIcons.drawer,
              tooltip: context.localize().openLabel,
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            titlePadding ??
            EdgeInsetsDirectional.only(
              start: hasLeading ? kToolbarLeadingPadding : 16.0,
              bottom: 14.0,
            ),
        title: title,
        expandedTitleScale: 1.0,
      ),
      actionsPadding: const EdgeInsetsDirectional.only(end: 8.0),
      actions: actions,
    );
  }
}

class FullSearchSliverAppBar extends StatefulWidget {
  const FullSearchSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.onSearchChanged,
    this.onAddPressed,
  });

  final Widget title;
  final List<Widget>? actions;
  final ValueChanged<String?> onSearchChanged;
  final ValueChanged<String>? onAddPressed;

  @override
  State<FullSearchSliverAppBar> createState() => _FullSearchSliverAppBarState();
}

class _FullSearchSliverAppBarState extends State<FullSearchSliverAppBar> {
  final controller = TextEditingController();
  bool inSearch = false;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);
    final hasLeading = layoutTier == LayoutTier.compact;

    return SimpleSliverAppBar(
      titlePadding: inSearch
          ? EdgeInsetsDirectional.only(
              start: hasLeading ? kToolbarLeadingPadding : 4.0,
              bottom: 4.0,
              top: 4.0,
              end: 4.0,
            )
          : null,
      title: inSearch
          ? SearchTextField(
              controller: controller,
              onDismissed: () => {
                setState(() {
                  inSearch = false;
                }),
              },
              onCleared: () => {
                setState(() {
                  inSearch = false;
                }),
              },
              onSearchChanged: widget.onSearchChanged,
              onAddPressed: widget.onAddPressed,
            )
          : widget.title,
      actions: inSearch
          ? null
          : [
              IconButton(
                icon: CommonIcons.search,
                tooltip: context.localize().searchLabel,
                onPressed: () {
                  setState(() {
                    inSearch = true;
                  });
                },
              ),
              ...?widget.actions,
            ],
    );
  }
}
