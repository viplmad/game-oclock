import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/fields/common.dart';
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
          ? TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                hintText: context.localize().searchLabel,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.onAddPressed != null &&
                        controller.text.isNotEmpty)
                      IconButton(
                        tooltip: context.localize().addLabel,
                        icon: CommonIcons.addInline,
                        onPressed: () => widget.onAddPressed!(controller.text),
                      ),
                    ClearIconButton(
                      onTap: () {
                        controller.clear();
                        widget.onSearchChanged(null);
                        setState(() {
                          inSearch = false;
                        });
                      },
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (final value) {
                if (widget.onAddPressed != null) {
                  setState(() {});
                }
                widget.onSearchChanged(value);
              },
            )
          : Text(widget.title),
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
