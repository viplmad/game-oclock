import 'package:flutter/material.dart';
import 'package:game_collection/ui/common/header_text.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../theme/theme.dart' show GameTheme;
import '../skeleton.dart';

class RatingField extends StatelessWidget {
  const RatingField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final int? value;
  final bool editable;
  final void Function(int)? update;

  @override
  Widget build(BuildContext context) {
    return ColumnListTile(
      center: true,
      title: HeaderText(
        text: fieldName,
      ),
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
    Key? key,
    required this.fieldName,
    this.order = 0,
  }) : super(key: key);

  final String fieldName;
  final int order;

  @override
  Widget build(BuildContext context) {
    return ColumnListTile(
      title: HeaderText(
        text: fieldName,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: Skeleton(
          height: 16,
          order: order,
        ),
      ),
    );
  }
}
