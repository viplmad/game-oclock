import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import '../common/year_picker_dialog.dart';
import 'list.dart';


class PurchaseAppBar extends ItemAppBar<Purchase, PurchaseListBloc> {
  const PurchaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = PurchaseTheme.primaryColour;

  @override
  void Function(int) onSelected(BuildContext context, List<String> views) {

    return (int selectedViewIndex) async {

      if(selectedViewIndex == views.length - 1) {
        int? year = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: PurchaseTheme.themeData(context),
              child: YearPickerDialog(),
            );
          },
        );

        if(year != null) {
          BlocProvider.of<PurchaseListBloc>(context).add(UpdateYearView(selectedViewIndex, year));
        }
      } else {

        BlocProvider.of<PurchaseListBloc>(context).add(UpdateView(selectedViewIndex));

      }
    };

  }

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchasesString;

  @override
  List<String> views(BuildContext context) => PurchaseTheme.views(context);
}

class PurchaseFAB extends ItemFAB<Purchase, PurchaseListManagerBloc> {
  const PurchaseFAB({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = PurchaseTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseString;
}

class PurchaseList extends ItemList<Purchase, PurchaseListBloc, PurchaseListManagerBloc> {
  const PurchaseList({
    Key? key,
  }) : super(key: key);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseString;

  @override
  _PurchaseListBody itemListBodyBuilder({required List<Purchase> items, required int viewIndex, int? viewYear, required void Function(Purchase) onDelete, required ListStyle style}) {

    return _PurchaseListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
    );

  }
}

class _PurchaseListBody extends ItemListBody<Purchase, PurchaseListBloc> {
  const _PurchaseListBody({
    Key? key,
    required List<Purchase> items,
    required int viewIndex,
    int? viewYear,
    required void Function(Purchase) onDelete,
    required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
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
  String itemTitle(Purchase item) => PurchaseTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => PurchaseTheme.views(context).elementAt(viewIndex) + ((viewYear != null)? ' (' + GameCollectionLocalisations.of(context).yearString(viewYear!) + ')' : '');

  @override
  Widget cardBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemGrid(context, item, onTap);
}