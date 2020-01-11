import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import '../entity/entity.dart';
import '../entity/tag.dart';

import 'package:game_collection/loading_icon.dart';

class TagView extends StatefulWidget {
  TagView({Key key, this.tag}) : super(key: key);

  final Tag tag;

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: widget.tag.getCard(),
      ),
      body: Center(),
    );

  }
}