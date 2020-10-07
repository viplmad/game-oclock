import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class StoreDetail extends ItemDetail<Store, StoreDetailBloc, StoreDetailManagerBloc> {
  const StoreDetail({
    Key key,
    @required Store item,
    void Function(Store item) onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  StoreDetailBloc detailBlocBuilder(StoreDetailManagerBloc managerBloc) {

    return StoreDetailBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
      managerBloc: managerBloc,
    );

  }

  @override
  StoreDetailManagerBloc managerBlocBuilder() {

    return StoreDetailManagerBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    StoreRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = StoreRelationManagerBloc<Purchase>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    return [
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),

      BlocProvider<StoreRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData storeTheme = contextTheme.copyWith(
      primaryColor: storeColour,
      accentColor: storeAccentColour,
    );

    return storeTheme;

  }

  @override
  _StoreDetailBody detailBodyBuilder() {

    return _StoreDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<StoreRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(StoreRelationManagerBloc<W> managerBloc) {

    return BlocProvider<StoreRelationBloc<W>>(
      create: (BuildContext context) {
        return StoreRelationBloc<W>(
          itemID: item.ID,
          iCollectionRepository: CollectionRepository(),
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _StoreDetailBody extends ItemDetailBody<Store, StoreDetailBloc, StoreDetailManagerBloc> {
  _StoreDetailBody({
    Key key,
    void Function(Store item) onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

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