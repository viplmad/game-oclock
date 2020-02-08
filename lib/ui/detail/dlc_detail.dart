import 'package:flutter/material.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item_detail.dart';


class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, @required this.ID, @required this.itemDetailBloc}) : super(key: key);

  final int ID;
  final ItemDetailBloc itemDetailBloc;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    itemDetailBloc.add(LoadItem(ID));

    return Scaffold(
      body: _DLCDetailBody(
        itemID: ID,
        itemDetailBloc: itemDetailBloc,
      ),
    );

  }

}

class _DLCDetailBody extends ItemDetailBody {

  _DLCDetailBody({
    Key key,
    @required int itemID,
    @required ItemDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    itemID: itemID,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemDetailFields(BuildContext context) {

    DLC dlc = (item as DLC);

    return [
      itemTextField(
        fieldName: dlc_nameField,
        value: dlc.name,
      ),
      itemYearField(
        fieldName: dlc_releaseYearField,
        value: dlc.releaseYear,
      ),
      itemDateTimeField(
        fieldName: dlc_finishDateField,
        value: dlc.finishDate,
      ),
      itemsSingleRelation(
        itemRelationBloc: itemRelationBlocFunction,
        tableName: gameTable,
        shownValue: dlc_baseGameField,
      ),
      itemsManyRelation(
        itemRelationBloc: itemRelationBlocFunction,
        tableName: purchaseTable,
      ),
    ];

  }

  @override
  DLCRelationBloc itemRelationBlocFunction(String tableName) {

    return DLCRelationBloc(
      dlcID: itemID,
      relationField: tableName,
      itemBloc: itemBloc,
    );

  }

}