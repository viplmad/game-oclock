import 'package:flutter/material.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';


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

    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Text(fieldName, style: Theme.of(context).textTheme.subtitle1),
            ),
          ],
        ),
        SmoothStarRating(
          allowHalfRating: false,
          starCount: 10,
          rating: (value?? 0).roundToDouble(),
          color: Colors.yellow,
          borderColor: Colors.orangeAccent,
          size: 35.0,
          onRated: editable? (double? newRating) {
            if (newRating != null) {
              final int updatedRating = newRating.toInt();

              update!(updatedRating);
            }
          } : null,
        ),
      ],
    );

  }
}