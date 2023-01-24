import 'package:flutter/material.dart';

import 'package:game_collection/ui/utils/field_utils.dart';

import 'skeleton.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
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
        width: FieldUtils.titleTextWidth,
        height: FieldUtils.titleTextHeight,
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
