import 'package:flutter/material.dart';

import 'package:game_oclock_client/api.dart' show GameDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'relation.dart';

class TagGameRelationList extends ItemRelationList<GameDTO, TagGameRelationBloc,
    TagGameRelationManagerBloc> {
  const TagGameRelationList({
    super.key,
    required super.relationName,
    required super.relationTypeName,
  }) : super(
          limitHeight: false,
          relationIcon: GameTheme.primaryIcon,
          hasImage: GameTheme.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemCard(context, item, onTap);
}
