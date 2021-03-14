import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

//import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class TagSearch extends ItemSearch<Tag, TagSearchBloc, TagListManagerBloc> {
  const TagSearch({
    Key? key,
  }) : super(key: key);

  @override
  TagSearchBloc searchBlocBuilder() {

    return TagSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  TagListManagerBloc managerBlocBuilder() {

    return TagListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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
  void Function() onTap(BuildContext context, Tag item) => () => {};

  @override
  TagListManagerBloc managerBlocBuilder() {

    return TagListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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
  Widget cardBuilder(BuildContext context, Tag item) => TagTheme.itemCard(context, item, onTap);
}