import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_collection/main.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';

import 'package:game_collection/loading_icon.dart';

class StartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DBConnector _db = PostgresConnector.getConnector();

  void _showSnackBar(String message){
    final snackBar = new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 1),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    _db.open().then( (dynamic data) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) =>
            HomePage(),
        ),
      );
    }, onError: (e) {
      _showSnackBar(e.toString());
    });

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Game Collection"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LoadingIcon(),
              Text("Loading...")
            ],
          ),
        ),
      ),
    );

  }

}