import 'package:flutter/material.dart';

import '../../utils/field_utils.dart';
import '../header_text.dart';
import '../../utils/shape_utils.dart';
import '../skeleton.dart';

class EnumField extends StatelessWidget {
  const EnumField({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.enumValues,
    required this.enumColours,
    required this.update,
  }) : super(key: key);

  final String fieldName;
  final int? value;
  final List<String> enumValues;
  final List<Color> enumColours;
  final Function(int) update;

  @override
  Widget build(BuildContext context) {
    return ColumnListTile(
      title: HeaderText(
        text: fieldName,
      ),
      subtitle: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: List<Widget>.generate(
          enumValues.length,
          (int index) {
            final TextTheme textTheme = Theme.of(context).textTheme;

            final String option = enumValues[index];
            final Color optionColour = enumColours.elementAt(index);

            return ChoiceChip(
              shape: ShapeUtils.chipShapeBorder,
              label: Text(option),
              labelStyle: textTheme.bodyText1?.copyWith(
                // Reduce size of chips
                fontSize: 14.0,
              ),
              selected: value == index,
              selectedColor: optionColour.withOpacity(0.5),
              pressElevation: 2.0, // Default is very high
              onSelected: (bool newChoice) {
                if (newChoice) {
                  update(index);
                }
              },
            );
          },
        ).toList(growable: false),
      ),
    );
  }
}

class SkeletonEnumField extends StatelessWidget {
  const SkeletonEnumField({
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
      subtitle: Skeleton(
        height: FieldUtils.subtitleTextHeight,
        order: order,
      ),
    );
  }
}
