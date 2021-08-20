import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart' show GameTagTheme;
import 'search.dart';


class GameTagSearch extends ItemSearch<GameTag, GameTagSearchBloc, GameTagListManagerBloc> {
  const GameTagSearch({
    Key? key,
  }) : super(key: key);

  @override
  GameTagSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return GameTagSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  GameTagListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return GameTagListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _GameTagSearchBody<GameTagSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, GameTag) onTap, required bool allowNewButton}) {

    return _GameTagSearchBody<GameTagSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class GameTagLocalSearch extends ItemLocalSearch<GameTag, GameTagListManagerBloc> {
  const GameTagLocalSearch({
    Key? key,
    required List<GameTag> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = '';

  @override
  void Function() onTap(BuildContext context, GameTag item) => () {};

  @override
  GameTagListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return GameTagListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _GameTagSearchBody<ItemLocalSearchBloc<GameTag>> itemSearchBodyBuilder({required void Function() Function(BuildContext, GameTag) onTap, required bool allowNewButton}) {

    return _GameTagSearchBody<ItemLocalSearchBloc<GameTag>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _GameTagSearchBody<K extends ItemSearchBloc<GameTag>> extends ItemSearchBody<GameTag, K, GameTagListManagerBloc> {
  const _GameTagSearchBody({
    Key? key,
    required void Function() Function(BuildContext, GameTag) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameTagString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gameTagsString;

  @override
  GameTag createItem(String query) => GameTag(id: -1, name: query);

  @override
  Widget cardBuilder(BuildContext context, GameTag item) => GameTagTheme.itemCard(context, item, onTap);
}