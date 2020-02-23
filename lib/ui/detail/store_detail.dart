import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class StoreDetail extends StatelessWidget {

  const StoreDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _StoreDetailBody(
        itemID: ID,
        itemDetailBloc: BlocProvider.of<StoreDetailBloc>(context)..add(LoadItem(ID)),
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
  List<Widget> itemFieldsBuilder(CollectionItem item) {

    Store store = (item as Store);

    return [
      itemTextField(
        fieldName: stor_nameField,
        value: store.name,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListManyRelation(
        itemType: Purchase,
      ),
    ];

  }

  @override
  StoreRelationBloc itemRelationBlocFunction(Type itemType) {

    return StoreRelationBloc(
      storeID: itemID,
      relationType: itemType,
      itemBloc: itemBloc,
    );

  }

}