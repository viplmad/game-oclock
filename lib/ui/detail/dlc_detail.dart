import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _DLCDetailBody(
        itemID: ID,
        itemDetailBloc: BlocProvider.of<DLCDetailBloc>(context)..add(LoadItem(ID)),
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
  List<Widget> itemFieldsBuilder(CollectionItem item) {

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
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListSingleRelation(
        tableName: gameTable,
        shownValue: dlc_baseGameField,
      ),
      itemListManyRelation(
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