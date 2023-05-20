import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      shownValue: shownValue ?? value,
      editable: editable,
      extended: isLongText,
      update: update,
      onTap: () async {
        final TextEditingController fieldController = TextEditingController();
        fieldController.text = value ?? '';

        return showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.editString(fieldName),
              ),
              content: TextField(
                controller: fieldController,
                keyboardType:
                    isLongText ? TextInputType.multiline : TextInputType.text,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: fieldName,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(context);
                  },
                ),
                TextButton(
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(
                      context,
                      fieldController.text.trim(),
                    );
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
