import 'package:flutter/material.dart';
import 'package:game_oclock/components/search_text_field.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class FullSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FullSearchAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.onSearchChanged,
    this.onAddPressed,
  });

  final String title;
  final List<Widget>? actions;
  final ValueChanged<String?> onSearchChanged;
  final ValueChanged<String>? onAddPressed;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<FullSearchAppBar> createState() => _FullSearchAppBarState();
}

class _FullSearchAppBarState extends State<FullSearchAppBar> {
  final controller = TextEditingController();
  bool inSearch = false;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
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
          : Text(widget.title),
      // Fixed elevation so background colour doesn't change on scroll
      elevation: 1.0,
      scrolledUnderElevation: 1.0,
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
