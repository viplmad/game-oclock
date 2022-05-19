import 'package:flutter/material.dart';

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
        ? () {
            onTap!().then((K? newValue) {
              if (newValue != null) {
                update!(newValue);
              }
            });
          }
        : null;

    return extended
        ? InkWell(
            onTap: onTapWrapped,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Text(
                    fieldName,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(shownValue ?? ''),
                ),
              ],
            ),
          )
        : ListTileTheme.merge(
            child: ListTile(
              title: Text(fieldName),
              trailing: Text(shownValue ?? ''),
              onTap: onTapWrapped,
              onLongPress: onLongPress,
            ),
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
    return extended
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: fieldName != null
                    ? Text(
                        fieldName!,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    : SizedBox(
                        height: 24,
                        child: Skeleton(
                          order: order,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Skeleton(
                  height: 16,
                  order: order,
                ),
              ),
            ],
          )
        : ListTileTheme.merge(
            child: ListTile(
              title: fieldName != null
                  ? Text(fieldName!)
                  : SizedBox(
                      height: 24,
                      child: Skeleton(
                        order: order,
                      ),
                    ),
              trailing: Skeleton(
                width: 100,
                height: 16,
                order: order,
              ),
            ),
          );
  }
}
