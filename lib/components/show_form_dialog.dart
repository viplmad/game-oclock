import 'package:flutter/material.dart';

Future<void> showFormDialog(
  final BuildContext context, {
  required final WidgetBuilder builder,
  required final ValueChanged<BuildContext> onSuccess,
  final ValueChanged<BuildContext>? onFailure,
}) async {
  return showDialog<bool>(context: context, builder: builder).then<void>((
    final bool? success,
  ) {
    if (success != null && success) {
      if (context.mounted) {
        onSuccess(context);
      }
    } else {
      if (context.mounted) {
        onFailure?.call(context);
      }
    }
  });
}
