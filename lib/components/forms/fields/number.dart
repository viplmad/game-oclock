import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SimpleRatingFormField extends StatelessWidget {
  const SimpleRatingFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    this.color,
    this.borderColor,
  });

  final FormControl<int> formControl;
  final String label;
  final bool readOnly;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(final BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (_, _, _) => SmoothStarRating(
        allowHalfRating: false,
        starCount: 10,
        rating: (formControl.value ?? 0).roundToDouble(),
        color: color,
        borderColor: borderColor,
        size: 35.0,
        onRated: readOnly
            ? null
            : (final double? newRating) {
                formControl.value = newRating?.toInt();
              },
      ),
    );
  }
}
