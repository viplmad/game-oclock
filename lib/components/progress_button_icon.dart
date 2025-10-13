import 'package:flutter/material.dart';
import 'package:game_oclock/constants/constants.dart';

class ProgressButtonIcon extends StatelessWidget {
  const ProgressButtonIcon({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: kIconSize,
      height: kIconSize,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
