import 'package:flutter/material.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:game_oclock/ui/utils/field_utils.dart';

import '../../theme/theme.dart' show GameTheme;
import '../header_text.dart';
import '../skeleton.dart';

class RatingField extends StatelessWidget {
  const RatingField({
    super.key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  });

  final String fieldName;
  final int? value;
  final bool editable;
  final void Function(int)? update;

  @override
  Widget build(BuildContext context) {
    return ExtendedFieldListTile(
      center: true,
      title: HeaderText(fieldName),
      subtitle: SmoothStarRating(
        allowHalfRating: false,
        starCount: 10,
        rating: (value ?? 0).roundToDouble(),
        color: GameTheme.ratingColour,
        borderColor: GameTheme.ratingBorderColour,
        size: 35.0,
        onRated: editable
            ? (double? newRating) {
                if (newRating != null) {
                  final int updatedRating = newRating.toInt();

                  update!(updatedRating);
                }
              }
            : null,
      ),
    );
  }
}

class SkeletonRatingField extends StatelessWidget {
  const SkeletonRatingField({
    super.key,
    required this.fieldName,
    this.order = 0,
  });

  final String fieldName;
  final int order;

  @override
  Widget build(BuildContext context) {
    return ExtendedFieldListTile(
      center: true,
      title: HeaderText(fieldName),
      subtitle: Skeleton(
        height: FieldUtils.subtitleTextHeight,
        order: order,
      ),
    );
  }
}
