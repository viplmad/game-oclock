import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/tag_view.dart';

const String tagTable = "Tag";

const tagFields = [IDField, nameField];

const nameField = 'Name';

class Tag extends Entity {

  final String name;

  Tag({@required int ID, this.name}) : super(ID: ID);

  factory Tag.fromDynamicMap(Map<String, dynamic> map) {

    return Tag(
      ID: map[IDField],
      name: map[nameField],
    );

  }

  static List<Tag> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Tag> tagsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Tag tag = Tag.fromDynamicMap(map[tagTable]);

      tagsList.add(tag);
    });

    return tagsList;

  }

  @override
  Widget getEssentialInfo({Function handleDelete}) {
    return ListTile(
      title: Text(this.name),
      trailing: FlatButton(
        child: Text("Delete", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        onPressed: handleDelete,
      ),
    );
  }

  @override
  Widget getCard(BuildContext context, {Function handleDelete}) {

    return GestureDetector(
      child: Card(
        child: this.getEssentialInfo(handleDelete: handleDelete),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>
              TagView(
                tag: this,
              )
          ),
        );
      },
    );

  }

}