import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class StoreDetail extends StatelessWidget {

  const StoreDetail({Key key, @required this.ID, @required this.itemDetailBloc}) : super(key: key);

  final int ID;
  final ItemDetailBloc itemDetailBloc;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    itemDetailBloc.add(LoadItem(ID));

    return Scaffold(
      body: _StoreDetailBody(
        itemID: ID,
        itemDetailBloc: itemDetailBloc,
      ),
    );

  }

}

class _StoreDetailBody extends ItemDetailBody {

  _StoreDetailBody({
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

    Store store = (item as Store);

    return [
      itemTextField(
        fieldName: stor_nameField,
        value: store.name,
      ),
      itemsManyRelation(
        tableName: purchaseTable,
      ),
    ];

  }

  @override
  StoreRelationBloc itemRelationBlocFunction(String tableName) {

    return StoreRelationBloc(
      storeID: itemID,
      relationField: tableName,
      itemBloc: itemBloc,
    );

  }

}