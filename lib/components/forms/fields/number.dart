import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SimpleRatingFormField extends StatefulWidget {
  const SimpleRatingFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.color,
    this.borderColor,
  });

  final ScalarNumberEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final Color? color;
  final Color? borderColor;

  @override
  State<SimpleRatingFormField> createState() => _SimpleRatingFormFieldState();
}

class _SimpleRatingFormFieldState extends State<SimpleRatingFormField> {
  @override
  Widget build(final BuildContext context) {
    return SmoothStarRating(
      allowHalfRating: false,
      starCount: 10,
      rating: (widget.controller.value ?? 0).roundToDouble(),
      color: widget.color,
      borderColor: widget.borderColor,
      size: 35.0,
      onRated: widget.readOnly
          ? null
          : (final double? newRating) {
              widget.controller.setValue(newRating?.toInt());
              setState(() {});
            },
    );
  }
}

class ScalarNumberEditingController extends ValueNotifier<int?> {
  ScalarNumberEditingController({final int? value}) : super(value);

  void clear() {
    value = null;
  }

  void setValue(final int? newValue) {
    value = newValue;
  }
}
