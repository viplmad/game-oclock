import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show GameAvailableDTO, DLCAvailableDTO;

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, DLCTheme;
import 'relation.dart';

class PlatformGameRelationList extends ItemRelationList<GameAvailableDTO,
    PlatformGameRelationBloc, PlatformGameRelationManagerBloc> {
  const PlatformGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: GameTheme.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, GameAvailableDTO item) =>
      GameTheme.itemAvailableCard(context, item, onTap);
}

class PlatformDLCRelationList extends ItemRelationList<DLCAvailableDTO,
    PlatformDLCRelationBloc, PlatformDLCRelationManagerBloc> {
  const PlatformDLCRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: DLCTheme.hasImage,
          detailRouteName: dlcDetailRoute,
          searchRouteName: dlcSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, DLCAvailableDTO item) =>
      DLCTheme.itemAvailableCard(context, item, onTap);
}
