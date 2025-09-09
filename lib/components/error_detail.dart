import 'package:flutter/material.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(child: Text(title)),
          OutlinedButton.icon(
            icon: const Icon(CommonIcons.reload),
            label: Text(
              context.localize().retryLabel,
              maxLines: 1,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: onRetryTap,
          ),
        ],
      ),
    );
  }
}
