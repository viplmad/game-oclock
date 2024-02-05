import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show TagTheme;
import 'search.dart';

class GameTagSearch
    extends ItemSearch<TagDTO, NewTagDTO, TagSearchBloc, TagListManagerBloc> {
  const GameTagSearch({
    super.key,
    required super.onTapReturn,
  }) : super(
          detailRouteName: tagDetailRoute,
        );

  @override
  TagSearchBloc searchBlocBuilder(
    GameOClockService collectionService,
  ) {
    return TagSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  TagListManagerBloc managerBlocBuilder(
    GameOClockService collectionService,
  ) {
    return TagListManagerBloc(
      collectionService: collectionService,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameTagSearchBody itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, TagDTO) onTap,
    required bool allowNewButton,
  }) {
    return _GameTagSearchBody(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _GameTagSearchBody extends ItemSearchBody<TagDTO, NewTagDTO,
    TagSearchBloc, TagListManagerBloc> {
  const _GameTagSearchBody({
    required super.onTap,
    super.allowNewButton = false,
  });

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.tagString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.tagsString;

  @override
  NewTagDTO createItem(String query) => NewTagDTO(name: query);

  @override
  Widget cardBuilder(BuildContext context, TagDTO item) =>
      TagTheme.itemCard(context, item, onTap);
}
