import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class PlatformSearch extends ItemSearch<Platform, PlatformSearchBloc, PlatformListManagerBloc> {
  const PlatformSearch({
    Key? key,
  }) : super(key: key);

  @override
  PlatformSearchBloc searchBlocBuilder() {

    return PlatformSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  PlatformListManagerBloc managerBlocBuilder() {

    return PlatformListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _PlatformSearchBody<PlatformSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, Platform) onTap, required bool allowNewButton}) {

    return _PlatformSearchBody<PlatformSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class PlatformLocalSearch extends ItemLocalSearch<Platform, PlatformListManagerBloc> {
  const PlatformLocalSearch({
    Key? key,
    required List<Platform> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  PlatformListManagerBloc managerBlocBuilder() {

    return PlatformListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _PlatformSearchBody<ItemLocalSearchBloc<Platform>> itemSearchBodyBuilder({required void Function() Function(BuildContext, Platform) onTap, required bool allowNewButton}) {

    return _PlatformSearchBody<ItemLocalSearchBloc<Platform>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _PlatformSearchBody<K extends ItemSearchBloc<Platform>> extends ItemSearchBody<Platform, K, PlatformListManagerBloc> {
  const _PlatformSearchBody({
    Key? key,
    required void Function() Function(BuildContext, Platform) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).platformString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).platformsString;

  @override
  Platform createItem(String query) => Platform(id: -1, name: query, iconURL: null, iconFilename: null, type: null);

  @override
  Widget cardBuilder(BuildContext context, Platform item) => PlatformTheme.itemCard(context, item, onTap);
}