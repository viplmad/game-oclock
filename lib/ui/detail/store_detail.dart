import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color storeColour = Colors.blueGrey;

class StoreDetail extends StatelessWidget {

  const StoreDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData storeTheme = contextTheme.copyWith(
      primaryColor: storeColour,
      accentColor: Colors.grey,
    );

    return Scaffold(
      body: Theme(
        data: storeTheme,
        child: _StoreDetailBody(
          itemID: ID,
          itemDetailBloc: BlocProvider.of<StoreDetailBloc>(context)..add(LoadItem(ID)),
        ),
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
        trailingBuilder: (List<CollectionItem> items) {
          List<Purchase> purchases = items.cast<Purchase>();

          double totalSpent = 0.0;
          double totalValue = 0.0;
          purchases.forEach( (Purchase purchase) {
            totalSpent += purchase.price;
            totalValue += purchase.originalPrice;
          });

          double totalSaved = totalValue - totalSpent;
          double totalPercentageSaved = totalValue > 0.0? (1 - totalSpent / totalValue) * 100 : 0.0;

          return [
            itemMoneySumField(
              fieldName: "Total Money Spent",
              value: totalSpent,
            ),
            itemMoneySumField(
              fieldName: "Total Money Saved",
              value: totalSaved,
            ),
            itemMoneySumField(
              fieldName: "Real Value",
              value: totalValue,
            ),
            itemPercentageField(
              fieldName: "Percentage Saved",
              value: totalPercentageSaved,
            ),
          ];
        },
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