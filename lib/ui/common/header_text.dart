import 'package:flutter/material.dart';

import 'skeleton.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.text,
    this.trailingWidget,
  }) : super(key: key);

  final String text;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    final bool hasTrailing = trailingWidget != null;
    final Widget titleWidget =
        Text(text, style: Theme.of(context).textTheme.subtitle1);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: hasTrailing ? 0.0 : 16.0,
      ),
      child: hasTrailing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleWidget,
                trailingWidget!,
              ],
            )
          : titleWidget,
    );
  }
}

class HeaderSkeleton extends StatelessWidget {
  const HeaderSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
        bottom: 10.0,
      ),
      child: SizedBox(
        height: 24,
        width: 200,
        child: Skeleton(),
      ),
    );
  }
}

class ColumnListTile extends StatelessWidget {
  const ColumnListTile({
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
      child: Column(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
        children: <Widget>[
          title,
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: subtitle,
          ),
        ],
      ),
    );
  }
}
