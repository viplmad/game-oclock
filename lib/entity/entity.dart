import 'package:flutter/material.dart';
import 'package:game_collection/entity_view/entity_view.dart';

const String IDField = 'ID';

abstract class Entity {
  final int ID;

  EntityView entityView;

  Entity({@required this.ID});

  String getFormattedTitle();

  String getFormattedSubtitle() {

    return "";

  }

  Widget getCard({Function handleDelete}) {

    return Card(
      child: ListTile(
        title: Text(this.getFormattedTitle()),
        subtitle: Text(this.getFormattedSubtitle()),
        trailing: FlatButton(
          child: Text("Delete", style: TextStyle(color: Colors.white),),
          color: Colors.red,
          onPressed: handleDelete
        ),
      ),
    );

  }

  Widget getModifyCard(BuildContext context, {Function handleDelete})  {

    return GestureDetector(
      child: this.getCard(
          handleDelete: handleDelete
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: this.entityBuilder,
          ),
        );
      },
    );

  }

  Widget entityBuilder(BuildContext context);

}