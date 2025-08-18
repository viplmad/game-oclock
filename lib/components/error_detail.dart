import 'package:flutter/material.dart';

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
          ElevatedButton(
            onPressed: onRetryTap,
            child: const Text('Error - Tap to refresh'), // TODO
          ),
        ],
      ),
    );
  }
}
