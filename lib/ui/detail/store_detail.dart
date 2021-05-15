import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart';
import 'item_detail.dart';


class StoreDetail extends ItemDetail<Store, StoreUpdateProperties, StoreDetailBloc, StoreDetailManagerBloc> {
  const StoreDetail({
    Key? key,
    required Store item,
    void Function(Store? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  StoreDetailBloc detailBlocBuilder(StoreDetailManagerBloc managerBloc) {

    return StoreDetailBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
      managerBloc: managerBloc,
    );

  }

  @override
  StoreDetailManagerBloc managerBlocBuilder() {

    return StoreDetailManagerBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder() {

    final StoreRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = StoreRelationManagerBloc<Purchase>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),

      BlocProvider<StoreRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),
    ];

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
          itemId: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository!,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _StoreDetailBody extends ItemDetailBody<Store, StoreUpdateProperties, StoreDetailBloc, StoreDetailManagerBloc> {
  _StoreDetailBody({
    Key? key,
    void Function(Store? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  String itemTitle(Store item) => StoreTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Store store) {

    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: store.name,
        item: store,
        itemUpdater: (String newValue) => store.copyWith(name: newValue),
        updateProperties: const StoreUpdateProperties(),
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return <Widget>[
      StorePurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseString,
        trailingBuilder: (List<Purchase> purchases) {

          double totalSpent = 0.0;
          double totalValue = 0.0;
          purchases.forEach( (Purchase purchase) {
            totalSpent += purchase.price;
            totalValue += purchase.originalPrice;
          });

          final double totalSaved = totalValue - totalSpent;
          final double totalPercentageSaved = totalValue > 0? (1 - totalSpent / totalValue) : 0;

          return <Widget>[
            itemMoneySumField(
              context,
              fieldName: GameCollectionLocalisations.of(context).totalMoneySpentString,
              value: totalSpent,
            ),
            itemMoneySumField(
              context,
              fieldName: GameCollectionLocalisations.of(context).totalMoneySavedString,
              value: totalSaved,
            ),
            itemMoneySumField(
              context,
              fieldName: GameCollectionLocalisations.of(context).realValueString,
              value: totalValue,
            ),
            itemPercentageField(
              context,
              fieldName: GameCollectionLocalisations.of(context).percentageSavedString,
              value: totalPercentageSaved,
            ),
          ];
        },
      ),
    ];

  }
}