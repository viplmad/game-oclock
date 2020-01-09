import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/store.dart';

import 'package:game_collection/game_search.dart';

import 'package:game_collection/loading_icon.dart';

class PurchaseView extends StatefulWidget {
  PurchaseView({Key key, this.purchase}) : super(key: key);

  final Purchase purchase;

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DBConnector _db = PostgresConnector.getConnector();

  void _showSnackBar(String message){
    final snackBar = new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

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

          return entity.getCard(
              context,
              handleDelete: () => handleDelete(entity.ID),
          );

        }
      },
    );

  }

  Widget showResultsNonExpandable(Entity result, String addText) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        if(result == null) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton(
              child: Text(addText),
              onPressed: () {},
            ),
          );
        } else {

          return result.getCard(context);

        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.purchase.description),
      ),
      body: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(IDField),
              subtitle: Text(widget.purchase.ID.toString()),
            ),
            GestureDetector(
              child: ListTile(
                title: Text(descriptionField),
                subtitle: Text(widget.purchase.description),
              ),
              onTap: () {
                TextEditingController fieldController = TextEditingController();
                fieldController.text = widget.purchase.description;

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Edit " + descriptionField),
                      content: TextField(
                        controller: fieldController,
                        decoration: InputDecoration(
                          hintText: "Description",
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Accept"),
                          onPressed: () {
                            Navigator.maybePop(context, fieldController.text);
                          },
                        )
                      ],
                    );
                  }
                ).then( (String newText) {
                  if (newText != null) {
                    _db.updateDescriptionPurchase(widget.purchase.ID, newText).then( (dynamic data) {

                      _showSnackBar("Updated");

                    }, onError: (e) {

                      _showSnackBar("Unable to update");

                    });
                  }
                });
              },
            ),
            ListTile(
              title: Text(priceField),
              subtitle: Text(widget.purchase.price?.toString() ?? ""),
            ),
            ListTile(
              title: Text(externalCreditField),
              subtitle: Text(widget.purchase.externalCredit?.toString() ?? ""),
            ),
            ListTile(
              title: Text(dateField),
              subtitle: Text(widget.purchase.date?.toIso8601String() ?? "Unknown"),
            ),
            ListTile(
              title: Text(originalPriceField),
              subtitle: Text(widget.purchase.originalPrice?.toString() ?? ""),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("Games", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getGamesFromPurchase(widget.purchase.ID),
                builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(
                    snapshot.data,
                    "Add Game",
                    handleNew: () {
                      showSearch<Game>(
                          context: context,
                          delegate: GameSearch(),
                      ).then( (Game result) {
                        if (result != null) {
                          _db.insertGamePurchase(result.ID, widget.purchase.ID).then( (dynamic data) {

                            _showSnackBar("Added " + result.getNameAndEdition());

                          }, onError: (e) {

                            _showSnackBar("Unable to add " + result.getNameAndEdition());

                          });
                        }
                      });
                    },
                    handleDelete: (int gameID) {
                      _db.deleteGamePurchase(gameID, widget.purchase.ID).then( (dynamic data) {

                        _showSnackBar("Deleted");

                      }, onError: (e) {

                        _showSnackBar("Unable to delete");

                      });
                    }
                  );

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
                stream: _db.getDLCsFromPurchase(widget.purchase.ID),
                builder: (BuildContext context, AsyncSnapshot<List<DLC>> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResults(snapshot.data, "Add DLC");

                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
              child: Text("Store", style: Theme.of(context).textTheme.subhead),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _db.getStoreFromPurchase(widget.purchase.ID),
                builder: (BuildContext context, AsyncSnapshot<Store> snapshot) {
                  if(!snapshot.hasData) { return LoadingIcon(); }

                  return showResultsNonExpandable(snapshot.data.ID < 0? null : snapshot.data, "Add Store");

                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}