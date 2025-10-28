import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        DateLocaleConfigBloc,
        LocaleBloc,
        ThemeModeBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/models/models.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:intl/intl.dart';

final List<DropdownField<ThemeMode>> themeModeOptions =
    List.unmodifiable(<DropdownField<ThemeMode>>[
      DropdownField(
        value: ThemeMode.dark,
        labelBuilder: (final context) => context.localize().darkLabel,
      ),
      DropdownField(
        value: ThemeMode.light,
        labelBuilder: (final context) => context.localize().lightLabel,
      ),
      DropdownField(
        value: ThemeMode.system,
        labelBuilder: (final context) => context.localize().systemDefaultLabel,
      ),
    ]);

final List<DropdownField<Locale>> localeOptions = AppLocalizations
    .supportedLocales
    .map(
      (final locale) => DropdownField(
        value: locale,
        labelBuilder: (final context) => locale.toLanguageTag(), // TODO
      ),
    )
    .toList(growable: false);

final List<DropdownField<int>> startingDayOfWeekOptions =
    <int>[
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday,
        ]
        .map(
          (final weekday) => DropdownField(
            value: weekday,
            labelBuilder: (final context) => DateFormat.EEEE().format(
              // Dec of 2025 starts on a monday, so can be used to format weekday easily
              DateTime(2025, DateTime.december, weekday),
            ),
          ),
        )
        .toList(growable: false);

/// Sample date which allows to check the date and time format
final sampleDateTime = DateTime(2020, DateTime.january, 23, 21, 45);

final List<DropdownField<String>> timeFormatOptions =
    <String>['HH:mm', 'HH.mm', 'HH \'h\' mm', 'H:mm', 'h:mm a', 'a h:mm']
        .map(
          (final pattern) => DropdownField(
            value: pattern,
            labelBuilder: (final context) {
              return DateFormat(pattern).format(sampleDateTime);
            },
          ),
        )
        .toList(growable: false);

final List<DropdownField<String>> dateFormatOptions =
    <String>[
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
        ]
        .map(
          (final pattern) => DropdownField(
            value: pattern,
            labelBuilder: (final context) =>
                DateFormat(pattern).format(sampleDateTime),
          ),
        )
        .toList(growable: false);

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
    return BlocBuilder<ThemeModeBloc, ActionState<ThemeMode>>(
      builder: (final context, final state) {
        final themeMode = (state is ActionFinal<ThemeMode, ThemeMode>)
            ? state.data
            : ThemeMode.system;

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
    return BlocBuilder<LocaleBloc, ActionState<Locale>>(
      builder: (final context, final state) {
        final locale = (state is ActionFinal<Locale, Locale>)
            ? state.data
            : Localizations.localeOf(context);

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
            : DateLocaleConfig.def();

        return Column(
          children: [
            SettingRadioTile(
              label: context.localize().chooseStartingDayOfWeekLabel,
              value: dateConfig.startingDayOfWeek,
              options: startingDayOfWeekOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: dateConfig.copyWith(startingDayOfWeek: newValue),
                    ),
                  ),
            ),
            SettingRadioTile(
              label: context.localize().chooseTimeFormatLabel,
              value: dateConfig.timeFormat.pattern!,
              options: timeFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: dateConfig.copyWith(
                        timeFormat: DateFormat(newValue),
                      ),
                    ),
                  ),
            ),
            SettingRadioTile(
              label: context.localize().chooseDateFormatLabel,
              value: dateConfig.dateFormat.pattern!,
              options: dateFormatOptions,
              onSuccess: (final context, final newValue) =>
                  context.read<DateLocaleConfigBloc>().add(
                    ActionStarted(
                      data: dateConfig.copyWith(
                        dateFormat: DateFormat(newValue),
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
  final T value;
  final List<DropdownField<T>> options;
  final void Function(BuildContext context, T newValue) onSuccess;

  @override
  Widget build(final BuildContext context) {
    final option = options.firstWhere(
      (final element) => element.value == value,
    );

    return ListTile(
      title: Text(label),
      subtitle: Text(option.labelBuilder(context)),
      onTap: () async =>
          await showDialog<T>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
              title: Text(label),
              content: RadioGroup<T>(
                groupValue: value,
                onChanged: (final value) => Navigator.pop(context, value),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options
                        .map(
                          (final option) => RadioListTile<T>(
                            title: Text(option.labelBuilder(context)),
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
              onSuccess(context, value);
            }
          }),
    );
  }
}
