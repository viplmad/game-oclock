import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionFinal, ActionState, DateLocaleConfigBloc;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

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
    return BlocBuilder<DateLocaleConfigBloc, ActionState<DateLocaleConfig>>(
      builder: (final context, final state) {
        final dateConfig =
            (state is ActionFinal<DateLocaleConfig, DateLocaleConfig>)
            ? state.data
            : DateLocaleConfig.def();

        return _SimpleDateFormField(
          key: key,
          controller: controller,
          label: label,
          required: required,
          readOnly: readOnly,
          firstDate: firstDate,
          lastDate: lastDate,
          dateConfig: dateConfig,
        );
      },
    );
  }
}

class _SimpleDateFormField extends StatefulWidget {
  const _SimpleDateFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.firstDate,
    required this.lastDate,
    required this.dateConfig,
  });

  final DateTimeEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateLocaleConfig dateConfig;

  @override
  State<_SimpleDateFormField> createState() => _SimpleDateFormFieldState();
}

class _SimpleDateFormFieldState extends State<_SimpleDateFormField> {
  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController(
      text: _buildTextValue(widget.controller.value),
    );

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return SimpleTextFormField(
      controller: textController,
      label: widget.label,
      required: widget.required,
      readOnly: false,
      onCleared: () {
        widget.controller.clear();
      },
      suffixIcons: [
        IconButton(
          tooltip: context.localize().showDatePicker,
          icon: CommonIcons.datePicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showDatePicker(
      context: context,
      initialDate: widget.controller.value ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    ).then<void>((final value) {
      if (value != null) {
        widget.controller.setValue(value);
        textController.setValue(_buildTextValue(value));

        setState(() {});
      }
    });
  }

  String? _buildTextValue(final DateTime? value) {
    if (value == null) {
      return null;
    }

    return widget.dateConfig.formatDate(value);
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
