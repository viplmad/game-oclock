import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/game.dart';

import 'package:game_collection/loading_icon.dart';

void main() => runApp(GameCollection());

class GameCollection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  void initState() {
    super.initState();

    _db.open();
  }

  Widget getTypesStream() {
    return StreamBuilder(
      stream: _db.getAllTypes(),
      builder: (BuildContext context, AsyncSnapshot<List<PurchaseType>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<PurchaseType> results = snapshot.data;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            PurchaseType result = results[index];

            return result.getCard(context);
          },
        );
      },

    );
  }

  Widget getGamesStream() {
    return StreamBuilder(
      stream: _db.getAllGames(),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Game> results = snapshot.data;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Game result = results[index];

            return result.getCard(context);
          },
        );
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All games"),
      ),
      body: Center(
        child: getGamesStream(),
      ),
    );
  }
}
