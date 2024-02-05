import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/field_utils.dart';

import 'skeleton.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    this.icon,
    required this.text,
    this.trailingWidget,
  });

  final IconData? icon;
  final String text;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: FieldUtils.tilePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(icon),
                    )
                  : const SizedBox(),
              HeaderText(text),
            ],
          ),
          trailingWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}

class ListHeaderSkeleton extends StatelessWidget {
  const ListHeaderSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: FieldUtils.tilePadding,
      child: SizedBox(
        width: FieldUtils.titleTextWidth,
        height: FieldUtils.titleTextHeight,
        child: Skeleton(),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class ExtendedFieldListTile extends StatelessWidget {
  const ExtendedFieldListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.center = false,
    this.onTap,
    this.onLongPress,
  });

  final Widget title;
  final Widget subtitle;
  final bool center;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: FieldUtils.tilePadding.copyWith(
          right: center
              ? FieldUtils.tilePadding.left
              : FieldUtils.tilePadding.right,
        ),
        child: Column(
          crossAxisAlignment:
              center ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: title,
            ),
            Align(
              alignment: center ? Alignment.center : Alignment.centerRight,
              child: subtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class FieldListTile extends StatelessWidget {
  const FieldListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final Widget title;
  final Widget subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          subtitle,
          trailing ?? const SizedBox(),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
