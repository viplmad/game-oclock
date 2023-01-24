import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'relation.dart';

class TagGameRelationList extends ItemRelationList<GameDTO, TagGameRelationBloc,
    TagGameRelationManagerBloc> {
  const TagGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          limitHeight: false,
          hasImage: GameTheme.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemCard(context, item, onTap);
}
