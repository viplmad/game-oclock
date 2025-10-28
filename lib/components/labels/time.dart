import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionFinal, ActionState, DateLocaleConfigBloc;
import 'package:game_oclock/models/date_locale_config.dart';

import 'text.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({super.key, required this.label, required this.value});

  final String label;
  final DateTime? value;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<DateLocaleConfigBloc, ActionState<DateLocaleConfig>>(
      builder: (final context, final state) {
        final dateConfig =
            (state is ActionFinal<DateLocaleConfig, DateLocaleConfig>)
            ? state.data
            : DateLocaleConfig.def();

        return _TimeLabel(
          key: key,
          label: label,
          value: value,
          dateConfig: dateConfig,
        );
      },
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({
    super.key,
    required this.label,
    required this.value,
    required this.dateConfig,
  });

  final String label;
  final DateTime? value;
  final DateLocaleConfig dateConfig;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? null : dateConfig.timeFormat.format(value!),
    );
  }
}
