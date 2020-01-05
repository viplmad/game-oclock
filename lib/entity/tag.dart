import 'package:flutter/material.dart';

import 'entity.dart';

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

}