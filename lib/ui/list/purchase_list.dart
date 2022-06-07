import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/model/list_style.dart';

import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PurchaseTheme;
import '../common/year_picker_dialog.dart';
import 'list.dart';

class PurchaseAppBar extends ItemAppBar<Purchase, PurchaseListBloc> {
  const PurchaseAppBar({
    Key? key,
  }) : super(
          key: key,
          themeColor: PurchaseTheme.primaryColour,
          gridAllowed: Purchase.hasImage,
          searchRouteName: purchaseSearchRoute,
          detailRouteName: purchaseDetailRoute,
        );

  @override
  void Function(int) onSelected(BuildContext context, List<String> views) {
    return (int selectedViewIndex) async {
      if (selectedViewIndex == views.length - 1) {
        final int? year = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: PurchaseTheme.themeData(context),
              child: const YearPickerDialog(),
            );
          },
        );

        if (year != null) {
          // Ignore because we will never get to use use unmounted context
          // ignore: use_build_context_synchronously
          BlocProvider.of<PurchaseListBloc>(context)
              .add(UpdateYearView(selectedViewIndex, year));
        }
      } else {
        BlocProvider.of<PurchaseListBloc>(context)
            .add(UpdateView(selectedViewIndex));
      }
    };
  }

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchaseString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchasesString;

  @override
  List<String> views(BuildContext context) => PurchaseTheme.views(context);
}

class PurchaseFAB extends ItemFAB<Purchase, PurchaseListManagerBloc> {
  const PurchaseFAB({
    Key? key,
  }) : super(
          key: key,
          themeColor: PurchaseTheme.secondaryColour,
        );

  @override
  Purchase createItem() => const Purchase(
        id: -1,
        description: '',
        price: 0.0,
        externalCredit: 0.0,
        date: null,
        originalPrice: 0.0,
        store: null,
      );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchaseString;
}

class PurchaseList
    extends ItemList<Purchase, PurchaseListBloc, PurchaseListManagerBloc> {
  const PurchaseList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: purchaseDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchaseString;

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseListBody itemListBodyBuilder({
    required List<Purchase> items,
    required int viewIndex,
    required int? viewYear,
    required void Function(Purchase) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _PurchaseListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _PurchaseListBody extends ItemListBody<Purchase, PurchaseListBloc> {
  const _PurchaseListBody({
    Key? key,
    required super.items,
    required super.viewIndex,
    required super.viewYear,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          key: key,
          detailRouteName: purchaseDetailRoute,
          searchRouteName: purchaseSearchRoute,
        );

  @override
  String itemTitle(Purchase item) => PurchaseTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) =>
      PurchaseTheme.views(context).elementAt(viewIndex) +
      ((viewYear != null)
          ? ' (${GameCollectionLocalisations.of(context).formatYear(viewYear!)})'
          : '');

  @override
  Widget cardBuilder(BuildContext context, Purchase item) =>
      PurchaseTheme.itemCard(context, item, onTap);
}
