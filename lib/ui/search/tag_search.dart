import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show TagTheme;
import 'search.dart';

class GameTagSearch
    extends ItemSearch<TagDTO, NewTagDTO, TagSearchBloc, TagListManagerBloc> {
  const GameTagSearch({
    Key? key,
    required super.onTapReturn,
  }) : super(
          key: key,
          detailRouteName: tagDetailRoute,
        );

  @override
  TagSearchBloc searchBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return TagSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  TagListManagerBloc managerBlocBuilder(
    GameCollectionService collectionService,
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
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagsString;

  @override
  NewTagDTO createItem(String query) => NewTagDTO(name: query);

  @override
  Widget cardBuilder(BuildContext context, TagDTO item) =>
      TagTheme.itemCard(context, item, onTap);
}
