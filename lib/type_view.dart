import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart';

import 'package:game_collection/loading_icon.dart';

class TypeView extends StatefulWidget {
  TypeView({Key key, this.type}) : super(key: key);

  final PurchaseType type;

  @override
  State<TypeView> createState() => _TypeViewState();
}

class _TypeViewState extends State<TypeView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(widget.type.name),
        ),
      ),
      body: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(IDField),
              subtitle: Text(widget.type.ID.toString()),
            ),
            ListTile(
              title: Text(nameField),
              subtitle: Text(widget.type.name),
            ),
            Divider(),
            Text("Purchases", style: Theme.of(context).textTheme.subhead),
            StreamBuilder(
              stream: _db.getPurchasesFromType(widget.type.ID),
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
          ],
        ),
      ),
    );

  }
}