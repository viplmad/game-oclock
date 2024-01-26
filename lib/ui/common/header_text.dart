import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/field_utils.dart';

import 'skeleton.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    Key? key,
    this.icon,
    required this.text,
    this.trailingWidget,
  }) : super(key: key);

  final IconData? icon;
  final String text;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 24.0,
        top: 8.0,
        bottom: 8.0,
      ),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 24.0,
        top: 10.0,
        bottom: 10.0,
      ),
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
    Key? key,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required this.title,
    required this.subtitle,
    this.center = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

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
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 24.0,
          top: 8.0,
          bottom: 8.0,
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
    Key? key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

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
