import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, PlatformAvailableDTO;

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, PlatformTheme;
import 'relation.dart';

class DLCGameRelationList extends ItemRelationList<GameDTO, DLCGameRelationBloc,
    DLCGameRelationManagerBloc> {
  const DLCGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          isSingleList: true,
          hasImage: GameTheme.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemCard(context, item, onTap);
}

class DLCPlatformRelationList extends ItemRelationList<PlatformAvailableDTO,
    DLCPlatformRelationBloc, DLCPlatformRelationManagerBloc> {
  const DLCPlatformRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: PlatformTheme.hasImage,
          detailRouteName: platformDetailRoute,
          searchRouteName: platformSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, PlatformAvailableDTO item) =>
      PlatformTheme.itemAvailableCard(context, item, onTap);
}
