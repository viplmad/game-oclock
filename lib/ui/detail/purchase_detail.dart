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


class PurchaseDetail extends ItemDetail<Purchase, PurchaseDetailBloc, PurchaseDetailManagerBloc> {
  const PurchaseDetail({Key key, @required Purchase item}) : super(item: item, key: key);

  @override
  PurchaseDetailBloc detailBlocBuilder(PurchaseDetailManagerBloc managerBloc) {

    return PurchaseDetailBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
      managerBloc: managerBloc,
    );

  }

  @override
  PurchaseDetailManagerBloc managerBlocBuilder() {

    return PurchaseDetailManagerBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    PurchaseRelationManagerBloc<Store> _storeRelationManagerBloc = PurchaseRelationManagerBloc<Store>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    PurchaseRelationManagerBloc<Game> _gameRelationManagerBloc = PurchaseRelationManagerBloc<Game>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    PurchaseRelationManagerBloc<DLC> _dlcRelationManagerBloc = PurchaseRelationManagerBloc<DLC>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    PurchaseRelationManagerBloc<PurchaseType> _typeRelationManagerBloc = PurchaseRelationManagerBloc<PurchaseType>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    return [
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
  ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData purchaseTheme = contextTheme.copyWith(
      primaryColor: purchaseColour,
      accentColor: purchaseAccentColour,
    );

    return purchaseTheme;

  }

  @override
  _PurchaseDetailBody detailBodyBuilder() {

    return _PurchaseDetailBody();

  }

  BlocProvider<PurchaseRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(PurchaseRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PurchaseRelationBloc<W>>(
      create: (BuildContext context) {
        return PurchaseRelationBloc<W>(
          itemID: item.ID,
          iCollectionRepository: CollectionRepository(),
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _PurchaseDetailBody extends ItemDetailBody<Purchase, PurchaseDetailBloc, PurchaseDetailManagerBloc> {

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Purchase purchase) {

    return [
      itemTextField(
        context,
        fieldName: purc_descriptionField,
        value: purchase.description,
      ),
      itemMoneyField(
        context,
        fieldName: purc_priceField,
        value: purchase.price,
      ),
      itemMoneyField(
        context,
        fieldName: purc_externalCreditField,
        value: purchase.externalCredit,
      ),
      itemDateTimeField(
        context,
        fieldName: purc_dateField,
        value: purchase.date,
      ),
      itemMoneyField(
        context,
        fieldName: purc_originalPriceField,
        value: purchase.originalPrice,
      ),
      itemPercentageField(
        fieldName: purc_discountField,
        value: purchase.discount,
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      PurchaseStoreRelationList(),
      PurchaseGameRelationList(),
      PurchaseDLCRelationList(),
      PurchaseTypeRelationList(
        shownName: 'Types',
      ),
    ];

  }

}