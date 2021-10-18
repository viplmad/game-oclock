import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:backend/game_collection_backend.dart' show GameCollectionRepository;

import 'package:game_collection/localisations/localisations.dart';

import 'package:game_collection/ui/route.dart';


void main() => runApp(const GameCollection());

class GameCollection extends StatelessWidget {
  const GameCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return RepositoryProvider<GameCollectionRepository>(
      create: (BuildContext context) {
        return GameCollectionRepository();
      },
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => GameCollectionLocalisations.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: connectRoute,
        onGenerateRoute: onGenerateRoute,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GameCollectionLocalisationsDelegate(),
        ],
        supportedLocales: const <Locale>[
          Locale('en', 'GB'),
          Locale('es', 'ES'),
          Locale('en'),
          Locale('es'),
        ],
      ),
    );
  }
}