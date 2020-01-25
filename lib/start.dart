import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_connector.dart';
import 'package:game_collection/persistence/db_manager.dart';

import 'package:game_collection/loading_icon.dart';
import 'package:game_collection/show_snackbar.dart';

import 'package:game_collection/homepage.dart';

class StartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DBConnector _db = DBManager().getConnector();

  void _showSnackBar(String message){

    showSnackBar(
      scaffoldState: scaffoldKey.currentState,
      message: message,
      seconds: 2,
    );
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: LoadingIcon(),
              ),
              Text("Connecting...")
            ],
          ),
      ),
    );

  }

}