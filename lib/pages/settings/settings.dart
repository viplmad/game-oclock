import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ActionState,
        ActionSuccess,
        DateLocaleConfigGetBloc,
        DateLocaleConfigSaveBloc,
        LocaleGetBloc,
        LocaleSaveBloc,
        ThemeModeGetBloc,
        ThemeModeSaveBloc;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/models/models.dart'
    show DateLocaleConfig, OptionField, OptionTextField;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:intl/intl.dart';

final List<OptionField<ThemeMode?>> _themeModeOptions =
    List.unmodifiable(<OptionField<ThemeMode?>>[
      OptionTextField(
        value: null,
        labelBuilder: (final context) => context.localize().systemDefaultLabel,
      ),
      OptionTextField(
        icon: CommonIcons.light,
        value: ThemeMode.light,
        labelBuilder: (final context) => context.localize().lightLabel,
      ),
      OptionTextField(
        icon: CommonIcons.dark,
        value: ThemeMode.dark,
        labelBuilder: (final context) => context.localize().darkLabel,
      ),
    ]);

final List<OptionField<Locale?>> _localeOptions =
    List.unmodifiable(<OptionField<Locale?>>[
      OptionTextField(
        value: null,
        labelBuilder: (final context) =>
            context.localize().systemDefaultLabelData(
              context.localize().formatLocale(Localizations.localeOf(context)),
            ),
      ),
      ...AppLocalizations.supportedLocales.map(
        (final locale) => OptionTextField(
          value: locale,
          labelBuilder: (final context) =>
              context.localize().formatLocale(locale),
        ),
      ),
    ]);

final List<OptionField<int?>> _startingDayOfWeekOptions = List.unmodifiable(
  <OptionField<int?>>[
    OptionField(
      value: null,
      widgetBuilder: (final context) => Localizations.override(
        context: context,
        // Trick to show system default regardless
        delegates: [GlobalMaterialLocalizations.delegate],
        child: Builder(
          builder: (final context) => Text(
            context.localize().systemDefaultLabelData(
              _formatWeekday(
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
      (final weekday) => OptionTextField(
        value: weekday,
        labelBuilder: (final context) => _formatWeekday(weekday),
      ),
    ),
  ],
);

String _formatWeekday(final int weekday) {
  return DateFormat.EEEE().format(
    // Dec of 2025 starts on a monday, so can be used to format weekday easily
    DateTime(2025, DateTime.december, weekday),
  );
}

/// Sample date which allows to check the date and time format
final _sampleDateTime = DateTime(2020, DateTime.january, 23, 21, 45);

final List<OptionField<String?>> _timeFormatOptions = List.unmodifiable(
  <OptionField<String?>>[
    OptionField(
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
              ).formatTimeOfDay(TimeOfDay.fromDateTime(_sampleDateTime)),
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
      (final pattern) => OptionTextField(
        value: pattern,
        labelBuilder: (final context) {
          return DateFormat(pattern).format(_sampleDateTime);
        },
      ),
    ),
  ],
);

final List<OptionField<String?>> _dateFormatOptions = List.unmodifiable(
  <OptionField<String?>>[
    OptionField(
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
              ).formatCompactDate(_sampleDateTime),
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
      (final pattern) => OptionTextField(
        value: pattern,
        labelBuilder: (final context) =>
            DateFormat(pattern).format(_sampleDateTime),
      ),
    ),
  ],
);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return _SettingsBuilder(title: context.localize().settingsTitle);
  }
}

class _SettingsBuilder extends StatelessWidget {
  const _SettingsBuilder({required this.title});

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
    return BlocBuilder<ThemeModeGetBloc, ActionState<ThemeMode>>(
      builder: (final context, final state) {
        final themeMode = (state is ActionSuccess<ThemeMode, void>)
            ? state.data
            : null;

        return _SettingRadioTile(
          icon: CommonIcons.theme,
          label: context.localize().chooseThemeLabel,
          value: themeMode,
          options: _themeModeOptions,
          onSuccess: (final context, final newValue) => context
              .read<ThemeModeSaveBloc>()
              .add(ActionStarted(data: newValue)),
        );
      },
    );
  }

  Widget _localeSettingBuilder() {
    return BlocBuilder<LocaleGetBloc, ActionState<Locale>>(
      builder: (final context, final state) {
        final locale = (state is ActionSuccess<Locale, void>)
            ? state.data
            : null;

        return _SettingRadioTile(
          icon: CommonIcons.language,
          label: context.localize().chooseLanguageLabel,
          value: locale,
          options: _localeOptions,
          onSuccess: (final context, final newValue) =>
              context.read<LocaleSaveBloc>().add(ActionStarted(data: newValue)),
        );
      },
    );
  }

  Widget _dateSettingsBuilder() {
    return BlocBuilder<DateLocaleConfigGetBloc, ActionState<DateLocaleConfig>>(
      builder: (final context, final state) {
        final dateConfig = (state is ActionSuccess<DateLocaleConfig, void>)
            ? state.data
            : const DateLocaleConfig.def();

        return Column(
          children: [
            _SettingRadioTile(
              label: context.localize().chooseStartingDayOfWeekLabel,
              value: dateConfig.startingDayOfWeek,
              options: _startingDayOfWeekOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigSaveBloc>().add(
                    ActionStarted(
                      data: DateLocaleConfig(
                        startingDayOfWeek: newValue,
                        dateFormat: dateConfig.dateFormat,
                        timeFormat: dateConfig.timeFormat,
                      ),
                    ),
                  ),
            ),
            _SettingRadioTile(
              label: context.localize().chooseTimeFormatLabel,
              value: dateConfig.timeFormat?.pattern,
              options: _timeFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigSaveBloc>().add(
                    ActionStarted(
                      data: DateLocaleConfig(
                        startingDayOfWeek: dateConfig.startingDayOfWeek,
                        dateFormat: dateConfig.dateFormat,
                        timeFormat: DateFormat(newValue),
                      ),
                    ),
                  ),
            ),
            _SettingRadioTile(
              label: context.localize().chooseDateFormatLabel,
              value: dateConfig.dateFormat?.pattern,
              options: _dateFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigSaveBloc>().add(
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

class _SettingRadioTile<T> extends StatelessWidget {
  const _SettingRadioTile({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onSuccess,
  });

  final Widget? icon;
  final String label;
  final T? value;
  final List<OptionField<T?>> options;
  final void Function(BuildContext context, T? newValue) onSuccess;

  @override
  Widget build(final BuildContext context) {
    final option = options.firstWhere(
      (final element) => element.value == value,
    );

    return ListTile(
      leading: icon,
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
                            secondary: option.icon,
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
