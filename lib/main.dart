import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/route.dart';
import 'ui/route_constants.dart';


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
      initialRoute: connectRoute,
      onGenerateRoute: onGenerateRoute,
    );

  }

}