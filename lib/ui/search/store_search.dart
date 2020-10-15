import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class StoreSearch extends ItemSearch<Store, StoreSearchBloc, StoreListManagerBloc> {

  @override
  StoreSearchBloc searchBlocBuilder() {

    return StoreSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  StoreListManagerBloc managerBlocBuilder() {

    return StoreListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _StoreSearchBody<StoreSearchBloc> itemSearchBodyBuilder({void Function() Function(BuildContext, Store) onTap, bool allowNewButton}) {

    return _StoreSearchBody<StoreSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }

}

class StoreLocalSearch extends ItemLocalSearch<Store, StoreListManagerBloc> {

  StoreLocalSearch({
    Key key,
    @required List<Store> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  StoreListManagerBloc managerBlocBuilder() {

    return StoreListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _StoreSearchBody<ItemLocalSearchBloc<Store>> itemSearchBodyBuilder({void Function() Function(BuildContext, Store) onTap, bool allowNewButton}) {

    return _StoreSearchBody<ItemLocalSearchBloc<Store>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }

}

class _StoreSearchBody<K extends ItemSearchBloc<Store>> extends ItemSearchBody<Store, K, StoreListManagerBloc> {
  const _StoreSearchBody({Key key, @required void Function() Function(BuildContext, Store) onTap, bool allowNewButton = false}) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).storeString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).storesString;

  @override
  ThemeData themeData(BuildContext context) => StoreTheme.themeData(context);

}