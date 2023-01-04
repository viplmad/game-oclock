import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:backend/model/model.dart' show ListStyle;
import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'list.dart';

class PlatformAppBar extends ItemAppBar<PlatformDTO, PlatformListBloc> {
  const PlatformAppBar({
    Key? key,
  }) : super(
          key: key,
          themeColor: PlatformTheme.primaryColour,
          gridAllowed: PlatformTheme.hasImage,
          searchRouteName: platformSearchRoute,
          detailRouteName: platformDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformsString;

  @override
  List<String> views(BuildContext context) => PlatformTheme.views(context);
}

class PlatformFAB
    extends ItemFAB<PlatformDTO, NewPlatformDTO, PlatformListManagerBloc> {
  const PlatformFAB({
    Key? key,
  }) : super(
          key: key,
          themeColor: PlatformTheme.primaryColour, // Keep primary, both black
        );

  @override
  NewPlatformDTO createItem() => NewPlatformDTO(name: '');

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformString;
}

class PlatformList
    extends ItemList<PlatformDTO, PlatformListBloc, PlatformListManagerBloc> {
  const PlatformList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: platformDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformString;

  @override
  // ignore: library_private_types_in_public_api
  _PlatformListBody itemListBodyBuilder({
    required List<PlatformDTO> items,
    required int viewIndex,
    required Object? viewArgs,
    required void Function(PlatformDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _PlatformListBody(
      items: items,
      viewIndex: viewIndex,
      viewArgs: viewArgs,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _PlatformListBody extends ItemListBody<PlatformDTO, PlatformListBloc> {
  const _PlatformListBody({
    Key? key,
    required super.items,
    required super.viewIndex,
    required super.viewArgs,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          key: key,
          detailRouteName: platformDetailRoute,
          searchRouteName: platformSearchRoute,
        );

  @override
  String itemTitle(PlatformDTO item) => PlatformTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) =>
      PlatformTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, PlatformDTO item) =>
      PlatformTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, PlatformDTO item) =>
      PlatformTheme.itemGrid(context, item, onTap);
}
