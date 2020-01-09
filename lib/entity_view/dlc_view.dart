import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import '../entity/entity.dart';
import '../entity/dlc.dart';

import 'package:game_collection/loading_icon.dart';

class DLCView extends StatefulWidget {
  DLCView({Key key, this.dlc}) : super(key: key);

  final DLC dlc;

  @override
  State<DLCView> createState() => _DLCViewState();
}

class _DLCViewState extends State<DLCView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dlc.name),
      ),
      body: Center(),
    );

  }
}