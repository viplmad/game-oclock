import 'package:flutter/material.dart';

import 'package:game_collection/ui/utils/field_utils.dart';

import '../header_text.dart';
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
        alignment: WrapAlignment.spaceAround,
        children: List<Widget>.generate(
          enumValues.length,
          (int index) {
            final TextTheme textTheme = Theme.of(context).textTheme;

            final String option = enumValues[index];
            final Color optionColour = enumColours.elementAt(index);

            return ChoiceChip(
              labelPadding: EdgeInsets.zero,
              labelStyle: textTheme.bodyLarge?.copyWith(
                // Reduce size of chips
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              label: Text(option),
              selected: value == index,
              selectedColor: optionColour.withOpacity(0.5),
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
