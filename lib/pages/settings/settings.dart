import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionFinal, ActionStarted, ActionState, LocaleBloc, ThemeModeBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/models/nav_destination.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

List<DropdownField<ThemeMode>> themeModeOptions =
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

List<DropdownField<Locale>> localeOptions = AppLocalizations.supportedLocales
    .map(
      (final locale) => DropdownField(
        value: locale,
        labelBuilder: (final context) => locale.toLanguageTag(), // TODO
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
          /* TODO
          Start week on x
          Use 24 hour time format
          date format
        */
          children: [
            BlocBuilder<ThemeModeBloc, ActionState<ThemeMode>>(
              builder: (final context, final state) {
                final themeMode = (state is ActionFinal<ThemeMode, ThemeMode>)
                    ? state.data
                    : ThemeMode.system;

                return SettingRadioTile(
                  label: context.localize().chooseThemeLabel,
                  value: themeMode,
                  options: themeModeOptions,
                  onSuccess: (final context, final newValue) => context
                      .read<ThemeModeBloc>()
                      .add(ActionStarted(data: newValue)),
                );
              },
            ),
            BlocBuilder<LocaleBloc, ActionState<Locale>>(
              builder: (final context, final state) {
                final locale = (state is ActionFinal<Locale, Locale>)
                    ? state.data
                    : Localizations.localeOf(context);

                return SettingRadioTile(
                  label: context.localize().chooseLanguageLabel,
                  value: locale,
                  options: localeOptions,
                  onSuccess: (final context, final newValue) => context
                      .read<LocaleBloc>()
                      .add(ActionStarted(data: newValue)),
                );
              },
            ),
          ],
        ),
      ),
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
