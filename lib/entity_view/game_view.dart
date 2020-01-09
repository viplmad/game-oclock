import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/platform.dart' as platform;
import 'package:game_collection/entity/dlc.dart' as dlc;
import 'package:game_collection/entity/tag.dart' as tag;

import 'package:game_collection/loading_icon.dart';

class GameView extends StatefulWidget {
  GameView({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final DBConnector _db = PostgresConnector.getConnector();

  Widget showResults(List results, String addText) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index == results.length) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton(
              child: Text(addText),
              onPressed: () {},
            ),
          );
        } else {
          Entity result = results[index];

          return result.getCard(context);
        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
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
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("Purchases", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getPurchasesFromGame(widget.game.ID),
                builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(snapshot.data, "Add Purchase");

                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("Platforms", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getPlatformsFromGame(widget.game.ID),
                builder: (BuildContext context, AsyncSnapshot<List<platform.Platform>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(snapshot.data, "Add Platform");

                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("DLCs", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getDLCsFromGame(widget.game.ID),
                builder: (BuildContext context, AsyncSnapshot<List<dlc.DLC>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(snapshot.data, "Add DLC");

                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("Tags", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getTagsFromGame(widget.game.ID),
                builder: (BuildContext context, AsyncSnapshot<List<tag.Tag>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(snapshot.data, "Add Tag");

                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}