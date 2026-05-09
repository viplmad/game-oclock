import 'package:duration_picker/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        CurrentLoginResponseGetBloc,
        CurrentUserGetBloc,
        DateLocaleConfigGetBloc,
        DateLocaleConfigSaveBloc,
        LocaleGetBloc,
        LocaleSaveBloc,
        LoginBloc,
        MinimizedLayoutBloc,
        ThemeModeGetBloc,
        ThemeModeSaveBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;
import 'package:game_oclock/pages/routes.dart';
import 'package:game_oclock/services/services.dart'
    show
        AuthService,
        DeviceService,
        ExternalGameService,
        GameService,
        GameSessionService,
        ListSearchService,
        ListStyleService,
        LocationService,
        PlaythroughService,
        RetryableApiClient,
        SettingsService,
        TagService,
        UserService;
import 'package:game_oclock/services/shared_preferences_repository.dart';
import 'package:game_oclock/utils/custom_material_localizations.dart';

void main() {
  usePathUrlStrategy();
  runApp(const GameOClockApp());
}

class GameOClockApp extends StatelessWidget {
  const GameOClockApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final sharedPrefsRepository = SharedPreferencesRepository();
    final authService = AuthService(sharedPrefsRepository);
    final settingsService = SettingsService(sharedPrefsRepository);

    final apiClient = RetryableApiClient();
    final userService = UserService(apiClient);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExternalGameService>(
          create: (_) => ExternalGameService(apiClient),
        ),
        RepositoryProvider<AuthService>(create: (_) => authService),
        RepositoryProvider<SettingsService>(create: (_) => settingsService),
        RepositoryProvider<UserService>(create: (_) => userService),
        RepositoryProvider<GameService>(create: (_) => GameService(apiClient)),
        RepositoryProvider<TagService>(create: (_) => TagService(apiClient)),
        RepositoryProvider<PlaythroughService>(
          create: (_) => PlaythroughService(),
        ),
        RepositoryProvider<LocationService>(
          create: (_) => LocationService(apiClient),
        ),
        RepositoryProvider<DeviceService>(
          create: (_) => DeviceService(apiClient),
        ),
        RepositoryProvider<GameSessionService>(
          create: (_) => GameSessionService(apiClient),
        ),
        RepositoryProvider<ListSearchService>(
          create: (_) => ListSearchService(sharedPrefsRepository),
        ),
        RepositoryProvider<ListStyleService>(
          create: (_) => ListStyleService(sharedPrefsRepository),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Data
          BlocProvider(
            create: (_) => CurrentLoginResponseGetBloc(service: authService),
          ),
          BlocProvider(create: (_) => CurrentUserGetBloc(service: userService)),
          BlocProvider(
            create: (_) =>
                LoginBloc(service: authService, apiClient: apiClient),
          ),
          // Config
          BlocProvider(
            create: (_) =>
                MinimizedLayoutBloc()..add(const ActionStarted(data: false)),
          ),
          BlocProvider(
            create: (_) =>
                ThemeModeGetBloc(service: settingsService)
                  ..add(ActionStarted.empty()),
          ),
          BlocProvider(
            create: (_) => ThemeModeSaveBloc(service: settingsService),
          ),
          BlocProvider(
            create: (_) =>
                LocaleGetBloc(service: settingsService)
                  ..add(ActionStarted.empty()),
          ),
          BlocProvider(create: (_) => LocaleSaveBloc(service: settingsService)),
          BlocProvider(
            create: (_) =>
                DateLocaleConfigGetBloc(service: settingsService)
                  ..add(ActionStarted.empty()),
          ),
          BlocProvider(
            create: (_) => DateLocaleConfigSaveBloc(service: settingsService),
          ),
        ],
        child: _createApp(),
      ),
    );
  }

  Widget _createApp() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ThemeModeSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, ThemeMode?>) {
              context.read<ThemeModeGetBloc>().add(const ActionRestarted());
            }
          },
        ),
        BlocListener<LocaleSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, Locale?>) {
              context.read<LocaleGetBloc>().add(const ActionRestarted());
            }
          },
        ),
        BlocListener<DateLocaleConfigSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, DateLocaleConfig?>) {
              context.read<DateLocaleConfigGetBloc>().add(
                const ActionRestarted(),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ThemeModeGetBloc, ActionState<ThemeMode>>(
        builder: (final context, final themeState) {
          final themeMode = (themeState is ActionSuccess<ThemeMode, void>)
              ? themeState.data
              : null;

          return BlocBuilder<LocaleGetBloc, ActionState<Locale>>(
            builder: (final context, final localeState) {
              final locale = (localeState is ActionSuccess<Locale, void>)
                  ? localeState.data
                  : null;

              return BlocBuilder<
                DateLocaleConfigGetBloc,
                ActionState<DateLocaleConfig>
              >(
                builder: (final context, final state) {
                  final dateConfig =
                      (state is ActionSuccess<DateLocaleConfig, void>)
                      ? state.data
                      : const DateLocaleConfig.def();

                  return MaterialApp.router(
                    title: 'Game o\'Clock',
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    themeMode: themeMode,
                    locale: locale,
                    localizationsDelegates: [
                      DurationPickerLocalizations.delegate,
                      AppLocalizations.delegate,
                      CustomMaterialLocalizationsDelegate(
                        GlobalMaterialLocalizations.delegate,
                        dateConfig,
                      ),
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    routerConfig: routerConfig,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
