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


class PurchaseDetail extends ItemDetail<Purchase, PurchaseDetailBloc> {
  const PurchaseDetail({Key key, @required Purchase item}) : super(item: item, key: key);

  @override
  PurchaseDetailBloc detailBlocBuilder() {

    return PurchaseDetailBloc(
      purchaseID: item.ID,
      collectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    return [
      blocProviderRelationBuilder<Store>(),
      blocProviderRelationBuilder<Game>(),
      blocProviderRelationBuilder<DLC>(),
      blocProviderRelationBuilder<PurchaseType>(),
    ];

  }

  @override
  ThemeData getThemeData(BuildContext context) {

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

  BlocProvider<PurchaseRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>() {

    return BlocProvider<PurchaseRelationBloc<W>>(
      create: (BuildContext context) {
        return PurchaseRelationBloc<W>(
          purchaseID: item.ID,
          collectionRepository: CollectionRepository(),
        )..add(LoadItemRelation());
      },
    );

  }

}

class _PurchaseDetailBody extends ItemDetailBody<Purchase, PurchaseDetailBloc> {

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