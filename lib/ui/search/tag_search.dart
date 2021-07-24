import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import 'search.dart';


class TagSearch extends ItemSearch<Tag, TagSearchBloc, TagListManagerBloc> {
  const TagSearch({
    Key? key,
  }) : super(key: key);

  @override
  TagSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return TagSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  TagListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return TagListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _TagSearchBody<TagSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, Tag) onTap, required bool allowNewButton}) {

    return _TagSearchBody<TagSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class TagLocalSearch extends ItemLocalSearch<Tag, TagListManagerBloc> {
  const TagLocalSearch({
    Key? key,
    required List<Tag> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = '';

  @override
  void Function() onTap(BuildContext context, Tag item) => () {};

  @override
  TagListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return TagListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _TagSearchBody<ItemLocalSearchBloc<Tag>> itemSearchBodyBuilder({required void Function() Function(BuildContext, Tag) onTap, required bool allowNewButton}) {

    return _TagSearchBody<ItemLocalSearchBloc<Tag>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _TagSearchBody<K extends ItemSearchBloc<Tag>> extends ItemSearchBody<Tag, K, TagListManagerBloc> {
  const _TagSearchBody({
    Key? key,
    required void Function() Function(BuildContext, Tag) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).tagString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).tagsString;

  @override
  Tag createItem(String query) => Tag(id: -1, name: query);

  @override
  Widget cardBuilder(BuildContext context, Tag item) => TagTheme.itemCard(context, item, onTap);
}