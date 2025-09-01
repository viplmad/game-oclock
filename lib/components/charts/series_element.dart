import 'package:flutter/material.dart';
import 'package:game_oclock/utils/theme_utils.dart';

class SeriesElement<N extends num> {
  const SeriesElement(this.index, this.domainLabel, this.value);

  final int index;
  final String domainLabel;
  final N value;
}

Color defaultThemeTextColor(final BuildContext context) {
  return isThemeDark(context) ? Colors.white : Colors.black87;
}
