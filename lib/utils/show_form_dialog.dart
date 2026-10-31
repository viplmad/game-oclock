import 'package:flutter/material.dart';

Future<void> showReturningDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  required void Function(BuildContext context, T data) onSuccess,
  ValueChanged<BuildContext>? onFailure,
}) async {
  return showDialog<T>(context: context, builder: builder).then<void>((
    T? result,
  ) {
    if (result != null) {
      if (context.mounted) {
        onSuccess(context, result);
      }
    } else {
      if (context.mounted) {
        onFailure?.call(context);
      }
    }
  });
}
