import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logic/game_oclock_logic.dart' show GameOClockService;

import 'package:game_oclock/ui/route.dart';
import 'package:game_oclock/ui/theme/app_theme.dart';

void main() => runApp(const GameOClock());

class GameOClock extends StatelessWidget {
  const GameOClock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    unawaited(
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );

    return RepositoryProvider<GameOClockService>(
      create: (BuildContext context) {
        return GameOClockService();
      },
      child: _createApp(),
    );
  }

  MaterialApp _createApp() {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.themeData(Brightness.light),
      darkTheme: AppTheme.themeData(Brightness.dark),
      initialRoute: connectRoute,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
