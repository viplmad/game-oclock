import 'package:flutter/material.dart';


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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Text(fieldName, style: Theme.of(context).textTheme.subtitle1),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: List<Widget>.generate(
            enumValues.length,
            (int index) {
              final String option = enumValues[index];
              final Color optionColour = enumColours.elementAt(index);

              return ChoiceChip(
                label: Text(option),
                labelStyle: const TextStyle(color: Colors.black87),
                selected: value == index,
                selectedColor: optionColour.withOpacity(0.5),
                pressElevation: 2.0,
                onSelected: (bool newChoice) {
                  if(newChoice) {
                    update(index);
                  }
                },
              );

            },
          ).toList(growable: false),
        ),
      ],
    );

  }
}