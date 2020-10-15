import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class PurchaseAppBar extends ItemAppBar<Purchase, PurchaseListBloc> {

  @override
  final Color themeColor = PurchaseTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchasesString;

  @override
  List<String> views(BuildContext context) => PurchaseTheme.views(context);

}

class PurchaseFAB extends ItemFAB<Purchase, PurchaseListManagerBloc> {

  @override
  final Color themeColor = PurchaseTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseString;

}

class PurchaseList extends ItemList<Purchase, PurchaseListBloc, PurchaseListManagerBloc> {

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseString;

  @override
  _PurchaseListBody itemListBodyBuilder({@required List<Purchase> items, @required int viewIndex, @required void Function(Purchase) onDelete, @required ListStyle style}) {

    return _PurchaseListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _PurchaseListBody extends ItemListBody<Purchase, PurchaseListBloc> {

  _PurchaseListBody({
    Key key,
    @required List<Purchase> items,
    @required int viewIndex,
    @required void Function(Purchase) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  final String localSearchRouteName = purchaseLocalSearchRoute;

  @override
  final String statisticsRouteName = purchaseStatisticsRoute;

  @override
  String viewTitle(BuildContext context) {

    return PurchaseTheme.views(context).elementAt(viewIndex);

  }

}