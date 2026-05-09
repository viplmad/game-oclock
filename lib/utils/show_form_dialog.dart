import 'package:flutter/material.dart';

Future<void> showReturningDialog<T>(
  final BuildContext context, {
  required final WidgetBuilder builder,
  required final void Function(BuildContext context, T data) onSuccess,
  final ValueChanged<BuildContext>? onFailure,
}) async {
  return showDialog<T>(context: context, builder: builder).then<void>((
    final T? result,
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
