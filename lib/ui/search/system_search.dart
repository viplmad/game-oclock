import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import 'search.dart';


class SystemSearch extends ItemSearch<System, SystemRepository, SystemSearchBloc, SystemListManagerBloc> {
  const SystemSearch({
    Key? key,
  }) : super(key: key);

  @override
  SystemSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return SystemSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  SystemListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return SystemListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _SystemSearchBody<SystemSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, System) onTap, required bool allowNewButton}) {

    return _SystemSearchBody<SystemSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class SystemLocalSearch extends ItemLocalSearch<System, SystemRepository, SystemListManagerBloc> {
  const SystemLocalSearch({
    Key? key,
    required List<System> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = '';

  @override
  void Function() onTap(BuildContext context, System item) => () {};

  @override
  SystemListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return SystemListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _SystemSearchBody<ItemLocalSearchBloc<System>> itemSearchBodyBuilder({required void Function() Function(BuildContext, System) onTap, required bool allowNewButton}) {

    return _SystemSearchBody<ItemLocalSearchBloc<System>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _SystemSearchBody<K extends ItemSearchBloc<System>> extends ItemSearchBody<System, SystemRepository, K, SystemListManagerBloc> {
  const _SystemSearchBody({
    Key? key,
    required void Function() Function(BuildContext, System) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).systemString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).systemsString;

  @override
  System createItem(String query) => System(id: -1, name: query, iconURL: null, iconFilename: null, generation: 0, manufacturer: null);

  @override
  Widget cardBuilder(BuildContext context, System item) => SystemTheme.itemCard(context, item, onTap);
}