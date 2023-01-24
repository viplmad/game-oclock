import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show PlatformDTO, PlatformAvailableDTO, DLCDTO, TagDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../common/show_date_picker.dart';
import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme, PlatformTheme, TagTheme;
import '../search/search_arguments.dart';
import 'relation.dart';

class GameDLCRelationList extends ItemRelationList<DLCDTO, GameDLCRelationBloc,
    GameDLCRelationManagerBloc> {
  const GameDLCRelationList({
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
  Widget cardBuilder(BuildContext context, DLCDTO item) =>
      DLCTheme.itemCard(context, item, onTap);
}

class GamePlatformRelationList extends ItemRelationList<PlatformAvailableDTO,
    GamePlatformRelationBloc, GamePlatformRelationManagerBloc> {
  const GamePlatformRelationList({
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
      PlatformTheme.itemCardAvailable(context, item, onTap);

  @override
  Future<PlatformAvailableDTO?> Function() onSearchTap(BuildContext context) {
    return () {
      return Navigator.pushNamed<PlatformDTO>(
        context,
        searchRouteName,
        arguments: const SearchArguments(
          onTapReturn: true,
        ),
      ).then<PlatformAvailableDTO?>((PlatformDTO? result) {
        if (result != null) {
          return showGameDatePicker(
            context: context,
          ).then<PlatformAvailableDTO?>((DateTime? value) {
            if (value != null) {
              return result.withAvailableDate(value);
            }

            return null;
          });
        }

        return null;
      });
    };
  }
}

class GameTagRelationList extends ItemRelationList<TagDTO, GameTagRelationBloc,
    GameTagRelationManagerBloc> {
  const GameTagRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: TagTheme.hasImage,
          detailRouteName: tagDetailRoute,
          searchRouteName: tagSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, TagDTO item) =>
      TagTheme.itemCard(context, item, onTap);
}
