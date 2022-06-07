import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item, Store, Purchase;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show StoreTheme;
import 'item_detail.dart';

class StoreDetail
    extends ItemDetail<Store, StoreDetailBloc, StoreDetailManagerBloc> {
  const StoreDetail({
    Key? key,
    required super.item,
    super.onUpdate,
  }) : super(key: key);

  @override
  StoreDetailBloc detailBlocBuilder(
    GameCollectionRepository collectionRepository,
    StoreDetailManagerBloc managerBloc,
  ) {
    return StoreDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );
  }

  @override
  StoreDetailManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return StoreDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    final StoreRelationManagerBloc<Purchase> purchaseRelationManagerBloc =
        StoreRelationManagerBloc<Purchase>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Purchase>(
        collectionRepository,
        purchaseRelationManagerBloc,
      ),
      BlocProvider<StoreRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return purchaseRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _StoreDetailBody detailBodyBuilder() {
    return _StoreDetailBody(
      onUpdate: onUpdate,
    );
  }

  BlocProvider<StoreRelationBloc<W>>
      blocProviderRelationBuilder<W extends Item>(
    GameCollectionRepository collectionRepository,
    StoreRelationManagerBloc<W> managerBloc,
  ) {
    return BlocProvider<StoreRelationBloc<W>>(
      create: (BuildContext context) {
        return StoreRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );
  }
}

// ignore: must_be_immutable
class _StoreDetailBody
    extends ItemDetailBody<Store, StoreDetailBloc, StoreDetailManagerBloc> {
  _StoreDetailBody({
    Key? key,
    super.onUpdate,
  }) : super(
          key: key,
          hasImage: Store.hasImage,
        );

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
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      StorePurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName:
            GameCollectionLocalisations.of(context).purchaseString,
        trailingBuilder: (List<Purchase> purchases) {
          double totalSpent = 0.0;
          double totalValue = 0.0;
          for (final Purchase purchase in purchases) {
            totalSpent += purchase.price;
            totalValue += purchase.originalPrice;
          }

          final double totalSaved = totalValue - totalSpent;
          final double totalPercentageSaved =
              totalValue > 0 ? (1 - totalSpent / totalValue) : 0;

          return <Widget>[
            itemMoneySumField(
              context,
              fieldName:
                  GameCollectionLocalisations.of(context).totalMoneySpentString,
              value: totalSpent,
            ),
            itemMoneySumField(
              context,
              fieldName:
                  GameCollectionLocalisations.of(context).totalMoneySavedString,
              value: totalSaved,
            ),
            itemMoneySumField(
              context,
              fieldName:
                  GameCollectionLocalisations.of(context).realValueString,
              value: totalValue,
            ),
            itemPercentageField(
              context,
              fieldName:
                  GameCollectionLocalisations.of(context).percentageSavedString,
              value: totalPercentageSaved,
            ),
          ];
        },
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        order: order++,
      ),
    ];
  }
}
