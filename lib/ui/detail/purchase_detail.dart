import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

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


class PurchaseDetail extends ItemDetail<Purchase, PurchaseDetailBloc, PurchaseDetailManagerBloc> {
  const PurchaseDetail({
    Key? key,
    required Purchase item,
    void Function(Purchase? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  PurchaseDetailBloc detailBlocBuilder(PurchaseDetailManagerBloc managerBloc) {

    return PurchaseDetailBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
      managerBloc: managerBloc,
    );

  }

  @override
  PurchaseDetailManagerBloc managerBlocBuilder() {

    return PurchaseDetailManagerBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  List<BlocProvider<dynamic>> relationBlocsBuilder() {

    final PurchaseRelationManagerBloc<Store> _storeRelationManagerBloc = PurchaseRelationManagerBloc<Store>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PurchaseRelationManagerBloc<Game> _gameRelationManagerBloc = PurchaseRelationManagerBloc<Game>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PurchaseRelationManagerBloc<DLC> _dlcRelationManagerBloc = PurchaseRelationManagerBloc<DLC>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PurchaseRelationManagerBloc<PurchaseType> _typeRelationManagerBloc = PurchaseRelationManagerBloc<PurchaseType>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return <BlocProvider<dynamic>>[
      blocProviderRelationBuilder<Store>(_storeRelationManagerBloc),
      blocProviderRelationBuilder<Game>(_gameRelationManagerBloc),
      blocProviderRelationBuilder<DLC>(_dlcRelationManagerBloc),
      blocProviderRelationBuilder<PurchaseType>(_typeRelationManagerBloc),

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

  BlocProvider<PurchaseRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(PurchaseRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PurchaseRelationBloc<W>>(
      create: (BuildContext context) {
        return PurchaseRelationBloc<W>(
          itemId: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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
        field: purc_descriptionField,
        value: purchase.description,
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).priceFieldString,
        field: purc_priceField,
        value: purchase.price,
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).externalCreditsFieldString,
        field: purc_externalCreditField,
        value: purchase.externalCredit,
      ),
      itemDateTimeField(
        context,
        fieldName: GameCollectionLocalisations.of(context).purchaseDateFieldString,
        field: purc_dateField,
        value: purchase.date,
      ),
      itemMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).originalPriceFieldString,
        field: purc_originalPriceField,
        value: purchase.originalPrice,
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