import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import '../entity/entity.dart';
import '../entity/system.dart';

import 'package:game_collection/loading_icon.dart';

class SystemView extends StatefulWidget {
  SystemView({Key key, this.system}) : super(key: key);

  final System system;

  @override
  State<SystemView> createState() => _SystemViewState();
}

class _SystemViewState extends State<SystemView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: widget.system.getEssentialInfo(),
      ),
      body: Center(),
    );

  }
}