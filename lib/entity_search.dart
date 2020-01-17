import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/loading_icon.dart';

class EntitySearch extends SearchDelegate<Entity> {
  EntitySearch({@required this.searchTable});

  final String searchTable;
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
        stream: _db.getSearchStream(searchTable, query),
        builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
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
        stream: _db.getSearchStream(searchTable, query),
        builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
          if (!snapshot.hasData) { return LoadingIcon(); }

          return listResults(snapshot.data);
        },
      );

    } else {

      return Container();

    }
  }

  Widget listResults(List<Entity> results) {

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        Entity result = results[index];

        return result.getCard(
          context: context,
          onTap: () {

            close(context, result);

          },
        );
      },
    );

  }

  /*Widget listSuggestions(List<Entity> results) {

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        Entity result = results[index];

        return ListTile(
          title: Text(result.getFormattedTitle()),
          onTap: () {
            query = result.getFormattedTitle();
            showResults(context);
          },
          trailing: IconButton(
            icon: Transform.rotate(
              angle: (-1.5),
              child: Icon(Icons.call_made),
            ),
            tooltip: "Auto-fill",
            onPressed: () {
              query = result.getFormattedTitle();
            },
          ),
        );
      },
    );

  }*/
}