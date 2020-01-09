import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import '../entity/entity.dart';
import '../entity/platform.dart';

import 'package:game_collection/loading_icon.dart';

class PlatformView extends StatefulWidget {
  PlatformView({Key key, this.platform}) : super(key: key);

  final Platform platform;

  @override
  State<PlatformView> createState() => _PlatformViewState();
}

class _PlatformViewState extends State<PlatformView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.platform.name),
      ),
      body: Center(),
    );

  }
}