import 'package:flutter/material.dart';

class ProgressButtonIcon extends StatelessWidget {
  const ProgressButtonIcon({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
