import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/fields/common.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    this.onDismissed,
    this.onCleared,
    required this.onSearchChanged,
    this.onAddPressed,
  });

  final TextEditingController controller;
  final VoidCallback? onDismissed;
  final VoidCallback? onCleared;
  final ValueChanged<String?> onSearchChanged;
  final ValueChanged<String>? onAddPressed;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(final BuildContext context) {
    return TextField(
      autofocus: true,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: context.localize().searchLabel,
        prefixIcon: widget.onDismissed == null
            ? null
            : IconButton(
                tooltip: context.localize().backLabel,
                icon: CommonIcons.back,
                onPressed: () => widget.onDismissed!(),
              ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.onAddPressed != null &&
                widget.controller.text.isNotEmpty)
              IconButton(
                tooltip: context.localize().createLabel,
                icon: CommonIcons.addInline,
                onPressed: () => widget.onAddPressed!(widget.controller.text),
              ),
            ClearIconButton(
              onTap: () {
                widget.controller.clear();
                widget.onCleared?.call();
                widget.onSearchChanged(null);
              },
            ),
          ],
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (final value) {
        widget.onSearchChanged(value);
        setState(() {});
      },
    );
  }
}
