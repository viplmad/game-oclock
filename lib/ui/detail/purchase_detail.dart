import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item, Purchase, Game, DLC, Store, PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show PurchaseTheme;
import 'item_detail.dart';


class PurchaseDetail extends ItemDetail<Purchase, PurchaseDetailBloc, PurchaseDetailManagerBloc> {
  const PurchaseDetail({
    Key? key,
    required Purchase item,
    void Function(Purchase? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  PurchaseDetailBloc detailBlocBuilder(GameCollectionRepository collectionRepository, PurchaseDetailManagerBloc managerBloc) {

    return PurchaseDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  PurchaseDetailManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return PurchaseDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(GameCollectionRepository collectionRepository) {

    final PurchaseRelationManagerBloc<Store> _storeRelationManagerBloc = PurchaseRelationManagerBloc<Store>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final PurchaseRelationManagerBloc<Game> _gameRelationManagerBloc = PurchaseRelationManagerBloc<Game>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final PurchaseRelationManagerBloc<DLC> _dlcRelationManagerBloc = PurchaseRelationManagerBloc<DLC>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final PurchaseRelationManagerBloc<PurchaseType> _typeRelationManagerBloc = PurchaseRelationManagerBloc<PurchaseType>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Store>(collectionRepository, _storeRelationManagerBloc),
      blocProviderRelationBuilder<Game>(collectionRepository, _gameRelationManagerBloc),
      blocProviderRelationBuilder<DLC>(collectionRepository, _dlcRelationManagerBloc),
      blocProviderRelationBuilder<PurchaseType>(collectionRepository, _typeRelationManagerBloc),

      BlocProvider<PurchaseRelationManagerBloc<Store>>(
        create: (BuildContext context) {
          return _storeRelationManagerBloc;
        },
      ),
      BlocProvider<PurchaseRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return _gameRelationManagerBloc;
        },
      ),
      BlocProvider<PurchaseRelationManagerBloc<DLC>>(
        create: (BuildContext context) {
          return _dlcRelationManagerBloc;
        },
      ),
      BlocProvider<PurchaseRelationManagerBloc<PurchaseType>>(
        create: (BuildContext context) {
          return _typeRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  _PurchaseDetailBody detailBodyBuilder() {

    return _PurchaseDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<PurchaseRelationBloc<W>> blocProviderRelationBuilder<W extends Item>(GameCollectionRepository collectionRepository, PurchaseRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PurchaseRelationBloc<W>>(
      create: (BuildContext context) {
        return PurchaseRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _PurchaseDetailBody extends ItemDetailBody<Purchase, PurchaseDetailBloc, PurchaseDetailManagerBloc> {
  _PurchaseDetailBody({
    Key? key,
    void Function(Purchase? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  String itemTitle(Purchase item) => PurchaseTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Purchase purchase) {

    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).descriptionFieldString,
        value: purchase.description,
        item: purchase,
        itemUpdater: (String newValue) => purchase.copyWith(description: newValue),
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).priceFieldString,
        value: purchase.price,
        item: purchase,
        itemUpdater: (double newValue) => purchase.copyWith(price: newValue),
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).externalCreditsFieldString,
        value: purchase.externalCredit,
        item: purchase,
        itemUpdater: (double newValue) => purchase.copyWith(externalCredit: newValue),
      ),
      itemDateTimeField(
        context,
        fieldName: GameCollectionLocalisations.of(context).purchaseDateFieldString,
        value: purchase.date,
        item: purchase,
        itemUpdater: (DateTime newValue) => purchase.copyWith(date: newValue),
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).originalPriceFieldString,
        value: purchase.originalPrice,
        item: purchase,
        itemUpdater: (double newValue) => purchase.copyWith(originalPrice: newValue),
      ),
      itemPercentageField(
        context,
        fieldName: GameCollectionLocalisations.of(context).discountFieldString,
        value: purchase.discount,
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return <Widget>[
      PurchaseStoreRelationList(
        relationName: GameCollectionLocalisations.of(context).storeString,
        relationTypeName: GameCollectionLocalisations.of(context).storeString,
      ),
      PurchaseGameRelationList(
        relationName: GameCollectionLocalisations.of(context).gamesString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      ),
      PurchaseDLCRelationList(
        relationName: GameCollectionLocalisations.of(context).dlcsString,
        relationTypeName: GameCollectionLocalisations.of(context).dlcString,
      ),
      PurchaseTypeRelationList(
        relationName: GameCollectionLocalisations.of(context).purchaseTypesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseTypeString,
      ),
    ];

  }
}