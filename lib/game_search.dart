import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';

import 'package:game_collection/loading_icon.dart';

class GameSearch extends SearchDelegate<Game> {
  final DBConnector _db = PostgresConnector.getConnector();

  int _maxResults = 25;
  int _maxSuggestions = 8;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      tooltip: "Back",
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: "Clear",
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length > 1) {
      return StreamBuilder(
        stream: _db.getGamesWithName(query),
        builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
          if (!snapshot.hasData) { return LoadingIcon(); }

          return listResults(snapshot.data);
        },
      );
    } else {
      return Center(child: Text("Try with more words"),);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length > 1) {
      return StreamBuilder(
        stream: _db.getGamesWithName(query),
        builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
          if (!snapshot.hasData) { return LoadingIcon(); }

          return listSuggestions(snapshot.data);
        },
      );
    } else {
      return Container();
    }
  }

  Widget listResults(List results) {

    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: results.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0,),
      itemBuilder: (BuildContext context, int index) {
        Game result = results[index];

        return GestureDetector(
          child: Card(
            child: result.getEssentialInfo(),
          ),
          onTap: () {

            close(context, result);

          },
        );
      },
    );

  }

  Widget listSuggestions(List results) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        Game result = results[index];

        return ListTile(
          title: Text(result.getNameAndEdition()),
          onTap: () {
            query = result.name;
            showResults(context);
          },
          trailing: IconButton(
            icon: Transform.rotate(
              angle: (-1.5),
              child: Icon(Icons.call_made),
            ),
            tooltip: "Auto-fill",
            onPressed: () {
              query = result.name;
            },
          ),
        );
      },
    );

  }
}