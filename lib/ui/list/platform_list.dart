import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Platform;
import 'package:backend/model/list_style.dart';

import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'list.dart';


class PlatformAppBar extends ItemAppBar<Platform, PlatformListBloc> {
  const PlatformAppBar({
    Key? key,
  }) : super(
    key: key,
    themeColor: PlatformTheme.primaryColour,
  );

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).platformsString;

  @override
  List<String> views(BuildContext context) => PlatformTheme.views(context);
}

class PlatformFAB extends ItemFAB<Platform, PlatformListManagerBloc> {
  const PlatformFAB({
    Key? key,
  }) : super(
    key: key,
    themeColor: PlatformTheme.primaryColour,
  );

  @override
  Platform createItem() => const Platform(id: -1, name: '', iconURL: null, iconFilename: null, type: null);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).platformString;
}

class PlatformList extends ItemList<Platform, PlatformListBloc, PlatformListManagerBloc> {
  const PlatformList({
    Key? key,
  }) : super(
    key: key,
    detailRouteName: platformDetailRoute,
  );

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).platformString;

  @override
  _PlatformListBody itemListBodyBuilder({required List<Platform> items, required int viewIndex, required int viewYear, required void Function(Platform) onDelete, required ListStyle style}) {

    return _PlatformListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
    );

  }
}

class _PlatformListBody extends ItemListBody<Platform, PlatformListBloc> {
  const _PlatformListBody({
    Key? key,
    required List<Platform> items,
    required int viewIndex,
    required int viewYear,
    required void Function(Platform) onDelete,
    required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
    onDelete: onDelete,
    style: style,
    detailRouteName: platformDetailRoute,
    localSearchRouteName: platformLocalSearchRoute,
  );

  @override
  String itemTitle(Platform item) => PlatformTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => PlatformTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, Platform item) => PlatformTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, Platform item) => PlatformTheme.itemGrid(context, item, onTap);
}