import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class PurchaseDetail extends StatelessWidget {

  const PurchaseDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _PurchaseDetailBody(
        itemID: ID,
        itemDetailBloc: BlocProvider.of<PurchaseDetailBloc>(context)..add(LoadItem(ID)),
      ),
    );

  }

}

class _PurchaseDetailBody extends ItemDetailBody {

  _PurchaseDetailBody({
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

    Purchase purchase = (item as Purchase);

    return [
      itemTextField(
        fieldName: purc_descriptionField,
        value: purchase.description,
      ),
      itemMoneyField(
        fieldName: purc_priceField,
        value: purchase.price,
      ),
      itemMoneyField(
        fieldName: purc_externalCreditField,
        value: purchase.externalCredit,
      ),
      itemDateTimeField(
        fieldName: purc_dateField,
        value: purchase.date,
      ),
      itemMoneyField(
        fieldName: purc_originalPriceField,
        value: purchase.originalPrice,
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListSingleRelation(
        tableName: storeTable,
      ),
      itemListManyRelation(
        tableName: gameTable,
      ),
      itemListManyRelation(
        tableName: dlcTable,
      ),
      itemListManyRelation( //TODO: show as chips
        tableName: typeTable,
      ),
    ];

  }

  @override
  PurchaseRelationBloc itemRelationBlocFunction(String tableName) {

    return PurchaseRelationBloc(
      purchaseID: itemID,
      relationField: tableName,
      itemBloc: itemBloc,
    );

  }

}