import 'package:flutter/material.dart';

import 'package:game_oclock_client/api.dart'
    show GameAvailableDTO, DLCAvailableDTO, GameDTO, DLCDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_oclock/ui/common/show_date_picker.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, DLCTheme;
import '../search/search_arguments.dart';
import 'relation.dart';

class PlatformGameRelationList extends ItemRelationList<GameAvailableDTO,
    PlatformGameRelationBloc, PlatformGameRelationManagerBloc> {
  const PlatformGameRelationList({
    super.key,
    required super.relationName,
    required super.relationTypeName,
  }) : super(
          relationIcon: GameTheme.primaryIcon,
          hasImage: GameTheme.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, GameAvailableDTO item) =>
      GameTheme.itemCardAvailable(context, item, onTap);

  @override
  Future<GameAvailableDTO?> Function() onSearchTap(BuildContext context) {
    return () {
      return Navigator.pushNamed<GameDTO>(
        context,
        searchRouteName,
        arguments: const SearchArguments(
          onTapReturn: true,
        ),
      ).then<GameAvailableDTO?>((GameDTO? result) {
        if (result != null) {
          return showGameDatePicker(
            context: context,
          ).then<GameAvailableDTO?>((DateTime? value) {
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

class PlatformDLCRelationList extends ItemRelationList<DLCAvailableDTO,
    PlatformDLCRelationBloc, PlatformDLCRelationManagerBloc> {
  const PlatformDLCRelationList({
    super.key,
    required super.relationName,
    required super.relationTypeName,
  }) : super(
          relationIcon: DLCTheme.primaryIcon,
          hasImage: DLCTheme.hasImage,
          detailRouteName: dlcDetailRoute,
          searchRouteName: dlcSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, DLCAvailableDTO item) =>
      DLCTheme.itemCardAvailable(context, item, onTap);

  @override
  Future<DLCAvailableDTO?> Function() onSearchTap(BuildContext context) {
    return () {
      return Navigator.pushNamed<DLCDTO>(
        context,
        searchRouteName,
        arguments: const SearchArguments(
          onTapReturn: true,
        ),
      ).then<DLCAvailableDTO?>((DLCDTO? result) {
        if (result != null) {
          return showGameDatePicker(
            context: context,
          ).then<DLCAvailableDTO?>((DateTime? value) {
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
