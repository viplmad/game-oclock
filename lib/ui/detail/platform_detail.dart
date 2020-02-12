import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class PlatformDetail extends StatelessWidget {

  const PlatformDetail({Key key, @required this.ID, @required this.itemDetailBloc}) : super(key: key);

  final int ID;
  final ItemDetailBloc itemDetailBloc;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    itemDetailBloc.add(LoadItem(ID));

    return Scaffold(
      body: _PlatformDetailBody(
        itemID: ID,
        itemDetailBloc: itemDetailBloc,
      ),
    );

  }

}

const List<Color> typeColours = [
  Colors.blueAccent,
  Colors.deepPurpleAccent,
];

class _PlatformDetailBody extends ItemDetailBody {

  _PlatformDetailBody({
    Key key,
    @required int itemID,
    @required ItemDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    itemID: itemID,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(BuildContext context) {

    Platform platform = (item as Platform);

    return [
      itemTextField(
        fieldName: plat_nameField,
        value: platform.name,
      ),
      itemChipField(
        fieldName: plat_typeField,
        value: platform.type,
        possibleValues: types,
        possibleValuesColours: typeColours,
      ),
      itemListManyRelation(
        tableName: gameTable,
      ),
      itemListManyRelation( //TODO: show as chips
        tableName: systemTable,
      ),
    ];

  }

  @override
  PlatformRelationBloc itemRelationBlocFunction(String tableName) {

    return PlatformRelationBloc(
      platformID: itemID,
      relationField: tableName,
      itemBloc: itemBloc,
    );

  }

}