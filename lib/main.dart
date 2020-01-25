import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_collection/start.dart';

void main() => runApp(GameCollection());


class GameCollection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Game Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }

}