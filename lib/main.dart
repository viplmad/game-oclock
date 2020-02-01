import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/ui/start.dart';
import 'package:game_collection/bloc/connection/connection.dart';
import 'package:game_collection/repository/collection_repository.dart';

void main() => runApp(GameCollection());


class GameCollection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider<ConnectionBloc>(
      create: (BuildContext context) {
        return ConnectionBloc(
          collectionRepository: CollectionRepository(),
        )..add(AppStarted());
      },
      child: MaterialApp(
        title: 'Game Collection',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StartPage(),
      ),
    );

  }

}