import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class StoreDetail extends ItemDetail<Store, StoreDetailBloc> {
  const StoreDetail({Key key, @required Store item}) : super(item: item, key: key);

  @override
  StoreDetailBloc detailBlocBuilder() {

    return StoreDetailBloc(
      storeID: item.ID,
      collectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    return [
      blocProviderRelationBuilder<Purchase>(),
    ];

  }

  @override
  ThemeData getThemeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData storeTheme = contextTheme.copyWith(
      primaryColor: storeColour,
      accentColor: storeAccentColour,
    );

    return storeTheme;

  }

  @override
  _StoreDetailBody detailBodyBuilder() {

    return _StoreDetailBody();

  }

  BlocProvider<StoreRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>() {

    return BlocProvider<StoreRelationBloc<W>>(
      create: (BuildContext context) {
        return StoreRelationBloc<W>(
          storeID: item.ID,
          collectionRepository: CollectionRepository(),
        )..add(LoadItemRelation());
      },
    );

  }

}

class _StoreDetailBody extends ItemDetailBody<Store, StoreDetailBloc> {

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Store store) {

    return [
      itemTextField(
        context,
        fieldName: stor_nameField,
        value: store.name,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      StorePurchaseRelationList(
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

}