import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

import 'common.dart';
import 'text.dart';

class SimpleDateFormField extends StatelessWidget {
  const SimpleDateFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(final BuildContext context) {
    final textController = TextEditingController();
    final calendarDelegate = const GregorianCalendarDelegate();
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    return SimpleTextFormField(
      controller: textController,
      label: label,
      required: required,
      readOnly: true,
      suffixIcons: [
        ClearIconButton(
          readOnly: readOnly,
          onTap: () {
            controller.clear();

            textController.clear();
            textController.clear();
          },
        ),
        IconButton(
          tooltip: context.localize().showDatePicker,
          icon: const Icon(CommonIcons.calendarPicker),
          onPressed: readOnly
              ? null
              : () async {
                  return showDatePicker(
                    context: context,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    calendarDelegate: calendarDelegate,
                  ).then<void>((final value) {
                    if (value != null) {
                      controller.setValue(value);

                      final formatCompactDate = calendarDelegate
                          .formatCompactDate(value, localizations);
                      textController.setValue(formatCompactDate);
                      textController.setValue(formatCompactDate);
                    }
                  });
                },
        ),
      ],
      maxLines: 1,
    );
  }
}

class DateTimeEditingController extends ValueNotifier<DateTime?> {
  DateTimeEditingController({final DateTime? date}) : super(date);

  void clear() {
    value = null;
  }

  void setValue(final DateTime? newValue) {
    value = newValue;
  }
}
