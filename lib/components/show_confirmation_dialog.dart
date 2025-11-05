import 'package:flutter/material.dart';

Future<void> showConfirmationDialog(
  final BuildContext context, {
  required final ConfirmationDialog Function(BuildContext context) builder,
  required final ValueChanged<BuildContext> onSuccess,
  final ValueChanged<BuildContext>? onFailure,
}) async {
  return showDialog<bool>(context: context, builder: builder).then<void>((
    final bool? result,
  ) {
    if (result != null && result) {
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

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.acceptLabel,
  });

  final String title;
  final String subtitle;
  final String message;
  final String acceptLabel;

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: ListTile(title: Text(message), subtitle: Text(subtitle)),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () async => await Navigator.maybePop(context),
        ),
        TextButton(
          onPressed: () async => await Navigator.maybePop(context, true),
          child: Text(acceptLabel),
        ),
      ],
    );
  }
}
