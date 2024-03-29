import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show PlatformDTO, NewPlatformDTO;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'list.dart';

class PlatformAppBar extends ItemAppBar<PlatformDTO, PlatformListBloc> {
  const PlatformAppBar({
    super.key,
  }) : super(
          themeColor: PlatformTheme.primaryColour,
          gridAllowed: PlatformTheme.hasImage,
          searchRouteName: platformSearchRoute,
          detailRouteName: platformDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.platformString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.platformsString;

  @override
  List<String> views(BuildContext context) => PlatformTheme.views(context);
}

class PlatformFAB
    extends ItemFAB<PlatformDTO, NewPlatformDTO, PlatformListManagerBloc> {
  const PlatformFAB({
    super.key,
  }) : super(
          themeColor: PlatformTheme.primaryColour, // Keep primary, both black
        );

  @override
  NewPlatformDTO createItem() => NewPlatformDTO(name: '');

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.platformString;
}

class PlatformList
    extends ItemList<PlatformDTO, PlatformListBloc, PlatformListManagerBloc> {
  const PlatformList({
    super.key,
  }) : super(
          detailRouteName: platformDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.platformString;

  @override
  // ignore: library_private_types_in_public_api
  _PlatformListBody itemListBodyBuilder({
    required List<PlatformDTO> items,
    required int viewIndex,
    required void Function(PlatformDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _PlatformListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _PlatformListBody extends ItemListBody<PlatformDTO, PlatformListBloc> {
  const _PlatformListBody({
    required super.items,
    required super.viewIndex,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          detailRouteName: platformDetailRoute,
        );

  @override
  String itemTitle(PlatformDTO item) => PlatformTheme.itemTitle(item);

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.platformsString;

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
