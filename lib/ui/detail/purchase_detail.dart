import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color purchaseColour = Colors.lightBlue;

class PurchaseDetail extends StatelessWidget {

  const PurchaseDetail({Key key, @required this.purchase}) : super(key: key);

  final Purchase purchase;

  @override
  Widget build(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData purchaseTheme = contextTheme.copyWith(
      primaryColor: purchaseColour,
      accentColor: Colors.lightBlueAccent,
    );

    return Scaffold(
      body: Theme(
        data: purchaseTheme,
        child: _PurchaseDetailBody(
          item: purchase,
          itemDetailBloc: BlocProvider.of<PurchaseDetailBloc>(context)..add(LoadItem(purchase.ID)),
        ),
      ),
    );

  }

}

class _PurchaseDetailBody extends ItemDetailBody<Purchase> {

  _PurchaseDetailBody({
    Key key,
    @required Purchase item,
    @required PurchaseDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    item: item,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(Purchase purchase) {

    return [
      itemTextField(
        fieldName: purc_descriptionField,
        value: purchase.description,
      ),
      itemMoneyField(
        fieldName: purc_priceField,
        value: purchase.price,
      ),
      itemMoneyField(
        fieldName: purc_externalCreditField,
        value: purchase.externalCredit,
      ),
      itemDateTimeField(
        fieldName: purc_dateField,
        value: purchase.date,
      ),
      itemMoneyField(
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
      itemListSingleRelation<Store>(),
      itemListManyRelation<Game>(),
      itemListManyRelation<DLC>(),
      itemListManyRelation<PurchaseType>( //TODO: show as chips
        shownName: 'Types',
      ),
    ];

  }

  @override
  PurchaseRelationBloc<W> itemRelationBlocFunction<W extends CollectionItem>() {

    return PurchaseRelationBloc<W>(
      purchaseID: item.ID,
      itemBloc: itemBloc,
    );

  }

}