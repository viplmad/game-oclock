import 'package:flutter/material.dart';
import 'package:game_oclock/components/forms/fields/common.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class SearchTextField extends StatelessWidget {
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
  Widget build(final BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: context.localize().searchLabel,
        prefixIcon: onDismissed == null
            ? null
            : IconButton(
                tooltip: context.localize().backLabel,
                icon: CommonIcons.back,
                onPressed: () => onDismissed!(),
              ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (onAddPressed != null && controller.text.isNotEmpty)
              IconButton(
                tooltip: context.localize().addLabel,
                icon: CommonIcons.addInline,
                onPressed: () => onAddPressed!(controller.text),
              ),
            ClearIconButton(
              onTap: () {
                controller.clear();
                onCleared?.call();
                onSearchChanged(null);
              },
            ),
          ],
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (final value) {
        onSearchChanged(value);
      },
    );
  }
}
