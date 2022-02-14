import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Store;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show StoreTheme;
import 'search.dart';

class StoreSearch
    extends ItemSearch<Store, StoreSearchBloc, StoreListManagerBloc> {
  const StoreSearch({
    Key? key,
    required bool onTapReturn,
    required int? viewIndex,
  }) : super(
          key: key,
          onTapReturn: onTapReturn,
          viewIndex: viewIndex,
          detailRouteName: storeDetailRoute,
        );

  @override
  StoreSearchBloc searchBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return StoreSearchBloc(
      collectionRepository: collectionRepository,
      viewIndex: viewIndex,
    );
  }

  @override
  StoreListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return StoreListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  _StoreSearchBody<StoreSearchBloc> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Store) onTap,
    required bool allowNewButton,
  }) {
    return _StoreSearchBody<StoreSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class StoreLocalSearch extends ItemLocalSearch<Store, StoreListManagerBloc> {
  const StoreLocalSearch({
    Key? key,
    required List<Store> items,
  }) : super(
          key: key,
          items: items,
          detailRouteName: storeDetailRoute,
        );

  @override
  StoreListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return StoreListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  _StoreSearchBody<ItemLocalSearchBloc<Store>> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Store) onTap,
    required bool allowNewButton,
  }) {
    return _StoreSearchBody<ItemLocalSearchBloc<Store>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _StoreSearchBody<K extends ItemSearchBloc<Store>>
    extends ItemSearchBody<Store, K, StoreListManagerBloc> {
  const _StoreSearchBody({
    Key? key,
    required void Function()? Function(BuildContext, Store) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).storeString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).storesString;

  @override
  Store createItem(String query) =>
      Store(id: -1, name: query, iconURL: null, iconFilename: null);

  @override
  Widget cardBuilder(BuildContext context, Store item) =>
      StoreTheme.itemCard(context, item, onTap);
}
