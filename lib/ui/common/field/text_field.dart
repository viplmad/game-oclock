import 'package:flutter/material.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'generic_field.dart';


class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.shownValue,
    this.editable = true,
    this.onLongPress,
    this.update,
    this.isLongText = false,
  }) : super(key: key);

  final String fieldName;
  final String? value;
  final String? shownValue;
  final bool editable;
  final void Function()? onLongPress;
  final void Function(String)? update;
  final bool isLongText;

  @override
  Widget build(BuildContext context) {

    return GenericField<String>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue?? value,
      editable: editable,
      extended: isLongText,
      update: update,
      onTap: () {
        final TextEditingController fieldController = TextEditingController();
        fieldController.text = value?? '';

        return showDialog<String>(
          context: context,
          builder: (BuildContext context) {

            return AlertDialog(
              title: Text(GameCollectionLocalisations.of(context).editString(fieldName)),
              content: TextField(
                controller: fieldController,
                keyboardType: isLongText? TextInputType.multiline : TextInputType.text,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: fieldName,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(context);
                  },
                ),
                TextButton(
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(context, fieldController.text.trim());
                  },
                ),
              ],
            );
          },
        );
      },
      onLongPress: onLongPress,
    );

  }
}