import 'package:flutter/material.dart';
import 'package:game_collection/entity/purchase.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import '../entity/entity.dart';
import '../entity/store.dart';

import 'package:game_collection/loading_icon.dart';

class StoreView extends StatefulWidget {
  StoreView({Key key, this.store}) : super(key: key);

  final Store store;

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  final DBConnector _db = PostgresConnector.getConnector();

  Widget showResults(List results, String addText, {Function handleNew, Function handleDelete}) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index == results.length) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton(
              child: Text(addText),
              onPressed: handleNew,
            ),
          );
        } else {
          Entity entity = results[index];

          return entity.getModifyCard(
            context,
            handleDelete: () => handleDelete(entity.ID),
          );

        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store.name),
      ),
        body: Center(
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
                  child: Text("Purchases", style: Theme.of(context).textTheme.subhead),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: _db.getPurchasesFromStore(widget.store.ID),
                    builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
                      if(!snapshot.hasData) { return LoadingIcon(); }

                      return showResults(snapshot.data, "Add Purchase", handleDelete: null);

                    },
                  ),
                ),
              ],
            )
        )
    );

  }
}