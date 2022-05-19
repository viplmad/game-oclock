import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show DLC;
import 'package:backend/model/list_style.dart';

import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme;
import 'list.dart';

class DLCAppBar extends ItemAppBar<DLC, DLCListBloc> {
  const DLCAppBar({
    Key? key,
  }) : super(
          key: key,
          themeColor: DLCTheme.primaryColour,
          searchRouteName: dlcSearchRoute,
        );

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).dlcsString;

  @override
  List<String> views(BuildContext context) => DLCTheme.views(context);
}

class DLCFAB extends ItemFAB<DLC, DLCListManagerBloc> {
  const DLCFAB({
    Key? key,
  }) : super(
          key: key,
          themeColor: DLCTheme.secondaryColour,
        );

  @override
  DLC createItem() => const DLC(
        id: -1,
        name: '',
        releaseYear: null,
        coverURL: null,
        coverFilename: null,
        baseGame: null,
        firstFinishDate: null,
      );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).dlcString;
}

class DLCList extends ItemList<DLC, DLCListBloc, DLCListManagerBloc> {
  const DLCList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: dlcDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).dlcString;

  @override
  // ignore: library_private_types_in_public_api
  _DLCListBody itemListBodyBuilder({
    required List<DLC> items,
    required int viewIndex,
    required int? viewYear,
    required void Function(DLC) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _DLCListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _DLCListBody extends ItemListBody<DLC, DLCListBloc> {
  const _DLCListBody({
    Key? key,
    required List<DLC> items,
    required int viewIndex,
    required int? viewYear,
    required void Function(DLC) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) : super(
          key: key,
          items: items,
          viewIndex: viewIndex,
          viewYear: viewYear,
          onDelete: onDelete,
          style: style,
          scrollController: scrollController,
          detailRouteName: dlcDetailRoute,
          searchRouteName: dlcSearchRoute,
        );

  @override
  String itemTitle(DLC item) => DLCTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) =>
      DLCTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, DLC item) =>
      DLCTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, DLC item) =>
      DLCTheme.itemGrid(context, item, onTap);
}
