import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_collection/main.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';

import 'package:game_collection/loading_icon.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}
class _StartPageState extends State<StartPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DBConnector _db = PostgresConnector.getConnector();

  bool _connectionOpen = false;
  bool _loading = false;

  void _showSnackBar(String message){
    final snackBar = new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 1),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handleOpen() {

    setState(() {
      _loading = true;
    });

    _db.open().then( (dynamic value) {
      setState(() {
        _connectionOpen = true;
        _loading = false;
      });
      _showSnackBar("Connection is now open");
    }, onError: (e) {
      setState(() {
        _loading = false;
      });
      _showSnackBar("Connection could not be opened");
    });

  }

  void _handleClose() {

    setState(() {
      _loading = true;
    });

    _db.close().then( (dynamic value) {
      setState(() {
        _connectionOpen = false;
        _loading = false;
      });
      _showSnackBar("Connection is now closed");
    }, onError: (e) {
      setState(() {
        _loading = false;
      });
      _showSnackBar("Connection could not be closed");
    });

  }

  void _handleEnter() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) =>
          HomePage(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Game Collection"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text("Open"),
                onPressed: _connectionOpen || _loading? null : _handleOpen,
              ),
              RaisedButton(
                child: Text("Close"),
                onPressed: !_connectionOpen || _loading? null : _handleClose,
              ),
              _loading? LoadingIcon() : Center(),
              Divider(),
              RaisedButton(
                child: Text("Enter Collection"),
                onPressed: !_connectionOpen || _loading? null : _handleEnter,
              )
            ],
          ),
        )
      ),
    );
  }
}