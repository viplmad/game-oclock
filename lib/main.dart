import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CurrentUserGetBloc,
        DateLocaleConfigBloc,
        MinimizedLayoutBloc,
        SavedLoginResponseGetBloc;
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/pages/routes.dart';
import 'package:game_oclock/services/services.dart'
    show
        AuthService,
        GameLogService,
        GameService,
        IGDBService,
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
        RepositoryProvider<GameLogService>(create: (_) => GameLogService()),
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
        ],
        child: _createApp(),
      ),
    );
  }

  MaterialApp _createApp() {
    return MaterialApp.router(
      title: 'Game o\'Clock',
      theme: ThemeData(
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: routerConfig,
    );
  }
}
