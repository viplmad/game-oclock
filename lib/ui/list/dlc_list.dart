import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart'
    show DLCDTO, NewDLCDTO, DLCWithFinishDTO;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme;
import 'list.dart';

class DLCAppBar extends ItemAppBar<DLCDTO, DLCListBloc> {
  const DLCAppBar({
    super.key,
  }) : super(
          themeColor: DLCTheme.primaryColour,
          gridAllowed: DLCTheme.hasImage,
          searchRouteName: dlcSearchRoute,
          detailRouteName: dlcDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcsString;

  @override
  List<String> views(BuildContext context) => DLCTheme.views(context);
}

class DLCFAB extends ItemFAB<DLCDTO, NewDLCDTO, DLCListManagerBloc> {
  const DLCFAB({
    super.key,
  }) : super(
          themeColor: DLCTheme.secondaryColour,
        );

  @override
  NewDLCDTO createItem() => NewDLCDTO(name: '');

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcString;
}

class DLCList extends ItemList<DLCDTO, DLCListBloc, DLCListManagerBloc> {
  const DLCList({
    super.key,
  }) : super(
          detailRouteName: dlcDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcString;

  @override
  // ignore: library_private_types_in_public_api
  _DLCListBody itemListBodyBuilder({
    required List<DLCDTO> items,
    required int viewIndex,
    required void Function(DLCDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _DLCListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _DLCListBody extends ItemListBody<DLCDTO, DLCListBloc> {
  const _DLCListBody({
    required super.items,
    required super.viewIndex,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          detailRouteName: dlcDetailRoute,
        );

  @override
  String itemTitle(DLCDTO item) => DLCTheme.itemTitle(item);

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcsString;

  @override
  String viewTitle(BuildContext context) =>
      DLCTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, DLCDTO item) {
    if (item is DLCWithFinishDTO) {
      return DLCTheme.itemCardFinish(context, item, onTap);
    }

    return DLCTheme.itemCard(context, item, onTap);
  }

  @override
  Widget gridBuilder(BuildContext context, DLCDTO item) =>
      DLCTheme.itemGrid(context, item, onTap);
}
