import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/store.dart';

import 'entity_view.dart';

class PurchaseView extends EntityView {
  PurchaseView({Key key, @required Purchase purchase}) : super(key: key, entity: purchase);

  @override
  State<EntityView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  Purchase getEntity() => widget.entity as Purchase;

  @override
  List<Widget> getListFields() {

    return [
      attributeBuilder(
          fieldName: IDField,
          value: getEntity().ID.toString()
      ),
    ];

  }
  /*
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
              child: EntityView.StreamBuilderEntities(
                  entityStream: _db.getGamesFromPurchase(widget.purchase.ID),
                  addText: "Add Game",
                  handleNew: (Game addedGame) {
                    _db.insertGamePurchase(addedGame.ID, widget.purchase.ID).then( (dynamic data) {

                      _showSnackBar("Added " + addedGame.getNameAndEdition());

                    }, onError: (e) {

                      _showSnackBar("Unable to add " + addedGame.getNameAndEdition());

                    });
                  },
                  handleDelete: (Game removedGame) {
                    _db.deleteGamePurchase(removedGame.ID, widget.purchase.ID).then( (dynamic data) {

                      _showSnackBar("Deleted " + removedGame.getNameAndEdition());

                    }, onError: (e) {

                      _showSnackBar("Unable to delete" + removedGame.getNameAndEdition());

                    });
                  }
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

                  return EntityView.showResults(
                      results: snapshot.data,
                      addText: "Add DLC"
                  );

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

                  return EntityView.showResultsNonExpandable(
                      result: snapshot.data.ID < 0? null : snapshot.data,
                      addText: "Add Store");

                },
              ),
            ),
          ],
        ),
      ),
    );

  }
  */
}