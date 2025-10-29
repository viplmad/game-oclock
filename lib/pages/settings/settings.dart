import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        DateLocaleConfigBloc,
        LocaleBloc,
        ThemeModeBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:intl/intl.dart';

final class SettingField<T> {
  final Widget? icon;
  final Widget Function(BuildContext context) widgetBuilder;
  final T value;
  final Color? color;

  const SettingField({
    this.icon,
    required this.widgetBuilder,
    required this.value,
    this.color,
  });
}

final class SettingTextField<T> extends SettingField<T> {
  final String Function(BuildContext context) labelBuilder;

  SettingTextField({
    super.icon,
    required this.labelBuilder,
    required super.value,
    super.color,
  }) : super(widgetBuilder: (final context) => Text(labelBuilder(context)));
}

final List<SettingField<ThemeMode?>> themeModeOptions =
    List.unmodifiable(<SettingField<ThemeMode?>>[
      SettingTextField(
        value: null,
        labelBuilder: (final context) => context.localize().systemDefaultLabel,
      ),
      SettingTextField(
        value: ThemeMode.dark,
        labelBuilder: (final context) => context.localize().darkLabel,
      ),
      SettingTextField(
        value: ThemeMode.light,
        labelBuilder: (final context) => context.localize().lightLabel,
      ),
    ]);

final List<SettingField<Locale?>> localeOptions =
    List.unmodifiable(<SettingField<Locale?>>[
      SettingTextField(
        value: null,
        labelBuilder: (final context) => context
            .localize()
            .systemDefaultLabelData(Localizations.localeOf(context)),
      ),
      ...AppLocalizations.supportedLocales.map(
        (final locale) => SettingTextField(
          value: locale,
          labelBuilder: (final context) => locale.toLanguageTag(), // TODO
        ),
      ),
    ]);

final List<SettingField<int?>> startingDayOfWeekOptions = List.unmodifiable(
  <SettingField<int?>>[
    SettingField(
      value: null,
      widgetBuilder: (final context) => Localizations.override(
        context: context,
        // Trick to show system default regardless
        delegates: [GlobalMaterialLocalizations.delegate],
        child: Builder(
          builder: (final context) => Text(
            context.localize().systemDefaultLabelData(
              formatWeekday(
                MaterialLocalizations.of(context).firstDayOfWeekIndex % 7,
              ),
            ),
          ),
        ),
      ),
    ),
    ...<int>[
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ].map(
      (final weekday) => SettingTextField(
        value: weekday,
        labelBuilder: (final context) => formatWeekday(weekday),
      ),
    ),
  ],
);

String formatWeekday(final int weekday) {
  return DateFormat.EEEE().format(
    // Dec of 2025 starts on a monday, so can be used to format weekday easily
    DateTime(2025, DateTime.december, weekday),
  );
}

/// Sample date which allows to check the date and time format
final sampleDateTime = DateTime(2020, DateTime.january, 23, 21, 45);

final List<SettingField<String?>> timeFormatOptions = List.unmodifiable(
  <SettingField<String?>>[
    SettingField(
      value: null,
      widgetBuilder: (final context) => Localizations.override(
        context: context,
        // Trick to show system default regardless
        delegates: [GlobalMaterialLocalizations.delegate],
        child: Builder(
          builder: (final context) => Text(
            context.localize().systemDefaultLabelData(
              MaterialLocalizations.of(
                context,
              ).formatTimeOfDay(TimeOfDay.fromDateTime(sampleDateTime)),
            ),
          ),
        ),
      ),
    ),
    ...<String>[
      'HH:mm',
      'HH.mm',
      'HH \'h\' mm',
      'H:mm',
      'h:mm a',
      'a h:mm',
    ].map(
      (final pattern) => SettingTextField(
        value: pattern,
        labelBuilder: (final context) {
          return DateFormat(pattern).format(sampleDateTime);
        },
      ),
    ),
  ],
);

final List<SettingField<String?>> dateFormatOptions = List.unmodifiable(
  <SettingField<String?>>[
    SettingField(
      value: null,
      widgetBuilder: (final context) => Localizations.override(
        context: context,
        // Trick to show system default regardless
        delegates: [GlobalMaterialLocalizations.delegate],
        child: Builder(
          builder: (final context) => Text(
            context.localize().systemDefaultLabelData(
              MaterialLocalizations.of(
                context,
              ).formatCompactDate(sampleDateTime),
            ),
          ),
        ),
      ),
    ),
    ...<String>[
      'MMM d, y',
      'd MMM, y',
      'M/d/y',
      'd/M/y',
      'y/M/d',
      'M-d-y',
      'd-M-y',
      'y-M-d',
      'M.d.y',
      'd.M.y',
      'y.M.d',
    ].map(
      (final pattern) => SettingTextField(
        value: pattern,
        labelBuilder: (final context) =>
            DateFormat(pattern).format(sampleDateTime),
      ),
    ),
  ],
);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return SettingsBuilder(title: context.localize().settingsTitle);
  }
}

class SettingsBuilder extends StatelessWidget {
  const SettingsBuilder({super.key, required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _themeSettingBuilder(),
            _localeSettingBuilder(),
            _dateSettingsBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _themeSettingBuilder() {
    return BlocBuilder<ThemeModeBloc, ActionState<ThemeMode?>>(
      builder: (final context, final state) {
        final themeMode = (state is ActionFinal<ThemeMode?, ThemeMode?>)
            ? state.data
            : null;

        return SettingRadioTile(
          label: context.localize().chooseThemeLabel,
          value: themeMode,
          options: themeModeOptions,
          onSuccess: (final context, final newValue) =>
              context.read<ThemeModeBloc>().add(ActionStarted(data: newValue)),
        );
      },
    );
  }

  Widget _localeSettingBuilder() {
    return BlocBuilder<LocaleBloc, ActionState<Locale?>>(
      builder: (final context, final state) {
        final locale = (state is ActionFinal<Locale?, Locale?>)
            ? state.data
            : null;

        return SettingRadioTile(
          label: context.localize().chooseLanguageLabel,
          value: locale,
          options: localeOptions,
          onSuccess: (final context, final newValue) =>
              context.read<LocaleBloc>().add(ActionStarted(data: newValue)),
        );
      },
    );
  }

  Widget _dateSettingsBuilder() {
    return BlocBuilder<DateLocaleConfigBloc, ActionState<DateLocaleConfig>>(
      builder: (final context, final state) {
        final dateConfig =
            (state is ActionFinal<DateLocaleConfig, DateLocaleConfig>)
            ? state.data
            : const DateLocaleConfig();

        return Column(
          children: [
            SettingRadioTile(
              label: context.localize().chooseStartingDayOfWeekLabel,
              value: dateConfig.startingDayOfWeek,
              options: startingDayOfWeekOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: DateLocaleConfig(
                        startingDayOfWeek: newValue,
                        dateFormat: dateConfig.dateFormat,
                        timeFormat: dateConfig.timeFormat,
                      ),
                    ),
                  ),
            ),
            SettingRadioTile(
              label: context.localize().chooseTimeFormatLabel,
              value: dateConfig.timeFormat?.pattern,
              options: timeFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: DateLocaleConfig(
                        startingDayOfWeek: dateConfig.startingDayOfWeek,
                        dateFormat: dateConfig.dateFormat,
                        timeFormat: DateFormat(newValue),
                      ),
                    ),
                  ),
            ),
            SettingRadioTile(
              label: context.localize().chooseDateFormatLabel,
              value: dateConfig.dateFormat?.pattern,
              options: dateFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: DateLocaleConfig(
                        startingDayOfWeek: dateConfig.startingDayOfWeek,
                        dateFormat: DateFormat(newValue),
                        timeFormat: dateConfig.timeFormat,
                      ),
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class SettingRadioTile<T> extends StatelessWidget {
  const SettingRadioTile({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSuccess,
  });

  final String label;
  final T? value;
  final List<SettingField<T?>> options;
  final void Function(BuildContext context, T? newValue) onSuccess;

  @override
  Widget build(final BuildContext context) {
    final option = options.firstWhere(
      (final element) => element.value == value,
    );

    return ListTile(
      title: Text(label),
      subtitle: option.widgetBuilder(context),
      onTap: () async =>
          await showDialog<_Result<T?>?>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
              title: Text(label),
              content: RadioGroup<T?>(
                groupValue: value,
                onChanged: (final value) =>
                    Navigator.pop(context, _Result(value)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options
                        .map(
                          (final option) => RadioListTile<T?>(
                            title: option.widgetBuilder(context),
                            value: option.value,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(context.localize().cancelLabel),
                  onPressed: () async =>
                      await Navigator.maybePop(context, null),
                ),
              ],
            ),
          ).then((final value) {
            if (value != null && context.mounted) {
              onSuccess(context, value.value);
            }
          }),
    );
  }
}

class _Result<T> {
  final T? value;
  _Result(this.value);
}
