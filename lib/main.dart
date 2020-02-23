import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/client/postgres_connector.dart';
import 'package:game_collection/client/cloudinary_connector.dart';

import 'package:game_collection/ui/bloc_provider_route.dart';


void main() => runApp(GameCollection());

class GameCollection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //Initial set of backend providers
    CollectionRepository(
      idbConnector: PostgresConnector(),
      iImageConnector: CloudinaryConnector(),
    );

    return MaterialApp(
      title: 'Game Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartProvider(),
    );

  }

}