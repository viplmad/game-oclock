import 'package:duration_picker/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        CurrentUserGetBloc,
        DateLocaleConfigBloc,
        LocaleBloc,
        MinimizedLayoutBloc,
        SavedLoginResponseGetBloc,
        ThemeModeBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/pages/routes.dart';
import 'package:game_oclock/services/services.dart'
    show
        AuthService,
        GameService,
        GameSessionService,
        IGDBService,
        LocationService,
        LoginService,
        SearchService,
        TagService,
        UserService;

void main() {
  usePathUrlStrategy();
  runApp(const GameOClockApp());
}

class GameOClockApp extends StatelessWidget {
  const GameOClockApp({super.key});

  @override
  Widget build(final BuildContext context) {
    const igdbClientId = String.fromEnvironment('IGDB_CLIENT_ID');
    if (igdbClientId.isEmpty) {
      throw Exception(
        'IGDB Client Id not set. Set through "IGDB_CLIENT_ID" environemnt variable.',
      );
    }
    const igdbClientSecret = String.fromEnvironment('IGDB_CLIENT_SECRET');
    if (igdbClientSecret.isEmpty) {
      throw Exception(
        'IGDB Client Secret not set. Set through "IGDB_CLIENT_SECRET" environemnt variable.',
      );
    }

    final authService = AuthService();
    final userService = UserService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IGDBService>(
          create: (_) => IGDBService(igdbClientId, igdbClientSecret),
        ),
        RepositoryProvider<AuthService>(create: (_) => authService),
        RepositoryProvider<UserService>(create: (_) => userService),
        RepositoryProvider<LoginService>(create: (_) => LoginService()),
        RepositoryProvider<GameService>(create: (_) => GameService()),
        RepositoryProvider<TagService>(create: (_) => TagService()),
        RepositoryProvider<LocationService>(create: (_) => LocationService()),
        RepositoryProvider<GameSessionService>(
          create: (_) => GameSessionService(),
        ),
        RepositoryProvider<SearchService>(create: (_) => SearchService()),
      ],
      child: MultiBlocProvider(
        providers: [
          // Data
          BlocProvider(
            create: (_) => SavedLoginResponseGetBloc(service: authService),
          ),
          BlocProvider(create: (_) => CurrentUserGetBloc(service: userService)),
          // Config
          BlocProvider(
            create: (_) =>
                MinimizedLayoutBloc()..add(const ActionStarted(data: false)),
          ),
          BlocProvider(create: (_) => DateLocaleConfigBloc()),
          BlocProvider(create: (_) => ThemeModeBloc()),
          BlocProvider(create: (_) => LocaleBloc()),
        ],
        child: _createApp(),
      ),
    );
  }

  Widget _createApp() {
    return BlocBuilder<ThemeModeBloc, ActionState<ThemeMode>>(
      builder: (final context, final themeState) {
        final themeMode = (themeState is ActionFinal<ThemeMode, ThemeMode>)
            ? themeState.data
            : null;

        return BlocBuilder<LocaleBloc, ActionState<Locale>>(
          builder: (final context, final localeState) {
            final locale = (localeState is ActionFinal<Locale, Locale>)
                ? localeState.data
                : null;

            return MaterialApp.router(
              title: 'Game o\'Clock',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: [
                DurationPickerLocalizations
                    .delegate, // TODO use instead of hoursabbr
                ...AppLocalizations.localizationsDelegates,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: routerConfig,
            );
          },
        );
      },
    );
  }
}
