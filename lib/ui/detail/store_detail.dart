import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color storeColour = Colors.blueGrey;

class StoreDetail extends StatelessWidget {

  const StoreDetail({Key key, @required this.store}) : super(key: key);

  final Store store;

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
          item: store,
          itemDetailBloc: BlocProvider.of<StoreDetailBloc>(context)..add(LoadItem(store.ID)),
        ),
      ),
    );

  }

}

class _StoreDetailBody extends ItemDetailBody<Store> {

  _StoreDetailBody({
    Key key,
    @required Store item,
    @required StoreDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    item: item,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(Store store) {

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
      itemListManyRelation<Purchase>(
        trailingBuilder: (List<Purchase> purchases) {

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
  StoreRelationBloc<W> itemRelationBlocFunction<W extends CollectionItem>() {

    return StoreRelationBloc<W>(
      storeID: item.ID,
      itemBloc: itemBloc,
    );

  }

}