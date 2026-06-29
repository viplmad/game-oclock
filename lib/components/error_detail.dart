import 'package:flutter/material.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class DetailError extends StatelessWidget {
  const DetailError({super.key, required this.title, required this.onRetryTap});

  final String title;
  final VoidCallback onRetryTap;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          OutlinedButton.icon(
            icon: CommonIcons.reload,
            label: Text(
              context.localize().retryLabel,
              style: const TextStyle(fontSize: 18.0, color: CommonColors.white),
            ),
            onPressed: onRetryTap,
          ),
        ],
      ),
    );
  }
}

class LabelError extends StatelessWidget {
  const LabelError({super.key, required this.label, required this.onRetryTap});

  final String label;
  final VoidCallback onRetryTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: OutlinedButton.icon(
        icon: CommonIcons.reload,
        label: Text(
          context.localize().retryLabel,
          style: const TextStyle(fontSize: 18.0, color: CommonColors.white),
        ),
        onPressed: onRetryTap,
      ),
    );
  }
}
