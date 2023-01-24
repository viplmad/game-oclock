import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, PlatformAvailableDTO, PlatformDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../common/show_date_picker.dart';
import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, PlatformTheme;
import '../search/search_arguments.dart';
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
