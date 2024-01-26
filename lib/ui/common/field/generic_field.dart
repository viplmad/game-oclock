import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/field_utils.dart';

import '../header_text.dart';
import '../skeleton.dart';

class GenericField<K> extends StatelessWidget {
  const GenericField({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.shownValue,
    this.editable = true,
    this.onTap,
    this.onLongPress,
    this.update,
    this.extended = false,
  }) : super(key: key);

  final String fieldName;
  final K? value;
  final String? shownValue;
  final bool editable;
  final Future<K?> Function()? onTap;
  final void Function()? onLongPress;
  final void Function(K)? update;

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final void Function()? onTapWrapped = editable
        ? () async {
            onTap!().then((K? newValue) {
              if (newValue != null) {
                update!(newValue);
              }
            });
          }
        : null;

    return extended
        ? ExtendedFieldListTile(
            title: HeaderText(fieldName),
            subtitle: BodyText(shownValue ?? ''),
            onTap: onTapWrapped,
            onLongPress: onLongPress,
          )
        : FieldListTile(
            title: HeaderText(fieldName),
            subtitle: BodyText(shownValue ?? ''),
            onTap: onTapWrapped,
            onLongPress: onLongPress,
          );
  }
}

class SkeletonGenericField extends StatelessWidget {
  const SkeletonGenericField({
    Key? key,
    this.fieldName,
    this.extended = false,
    this.order = 0,
  }) : super(key: key);

  final String? fieldName;
  final bool extended;
  final int order;

  @override
  Widget build(BuildContext context) {
    final Widget title = fieldName != null
        ? HeaderText(fieldName!)
        : SizedBox(
            height: FieldUtils.titleTextHeight,
            child: Skeleton(
              order: order,
            ),
          );
    final Widget subtitle = Skeleton(
      width: FieldUtils.subtitleTextWidth,
      height: FieldUtils.subtitleTextHeight,
      order: order,
    );

    return extended
        ? ExtendedFieldListTile(
            title: title,
            subtitle: subtitle,
          )
        : FieldListTile(
            title: title,
            subtitle: subtitle,
          );
  }
}
