import 'package:flutter/material.dart';

import '../header_text.dart';
import '../shape_utils.dart';
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
            final String option = enumValues[index];
            final Color optionColour = enumColours.elementAt(index);

            return ChoiceChip(
              shape: ShapeUtils.chipShapeBorder,
              label: Text(option),
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
