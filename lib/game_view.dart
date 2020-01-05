import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'entity/entity.dart';
import 'entity/game.dart';
import 'entity/purchase.dart';

import 'package:game_collection/loading_icon.dart';

class GameView extends StatefulWidget {
  GameView({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(widget.game.name),
          subtitle: Text(widget.game.edition),
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(IDField),
              subtitle: Text(widget.game.ID.toString()),
            ),
            ListTile(
              title: Text(nameField),
              subtitle: Text(widget.game.name),
            ),ListTile(
              title: Text(editionField),
              subtitle: Text(widget.game.edition),
            ),
            ListTile(
              title: Text(releaseYearField),
              subtitle: Text(widget.game.releaseYear.toString()),
            ),
            ListTile(
              title: Text(coverField),
              subtitle: Text(widget.game.cover.toString()),
            ),
            ListTile(
              title: Text(statusField),
              subtitle: Text(widget.game.status),
            ),
            ListTile(
              title: Text(ratingField),
              subtitle: Text(widget.game.rating.toString() + "/10"),
            ),
            ListTile(
              title: Text(thoughtsField),
              subtitle: Text(widget.game.thoughts),
            ),
            ListTile(
              title: Text(timeField),
              subtitle: Text(widget.game.time.toString()),
            ),
            ListTile(
              title: Text(saveFolderField),
              subtitle: Text(widget.game.saveFolder),
            ),
            ListTile(
              title: Text(screenshotFolderField),
              subtitle: Text(widget.game.screenshotFolder),
            ),
            ListTile(
              title: Text(finishDateField),
              subtitle: Text(widget.game.finishDate?.toIso8601String() ?? "Not finished"),
            ),
            ListTile(
              title: Text(backupField),
              subtitle: Text(widget.game.isBackup.toString()),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Purchases", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getPurchasesFromGame(widget.game.ID),
                builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  List<Purchase> results = snapshot.data;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) {
                      Purchase result = results[index];

                      return result.getCard(context);
                    },
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );

  }
}