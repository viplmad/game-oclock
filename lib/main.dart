import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionStarted, DateLocaleConfigBloc, MinimizedLayoutBloc;
import 'package:game_oclock/data/services/igdb_service.dart';
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/pages/routes.dart';

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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IGDBService>(
          create: (_) => IGDBService(igdbClientId, igdbClientSecret),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
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
