import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show System;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart' show SystemTheme;
import 'search.dart';

class SystemSearch
    extends ItemSearch<System, SystemSearchBloc, SystemListManagerBloc> {
  const SystemSearch({
    Key? key,
    required super.onTapReturn,
    required super.viewIndex,
  }) : super(key: key);

  @override
  SystemSearchBloc searchBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return SystemSearchBloc(
      collectionRepository: collectionRepository,
      viewIndex: viewIndex,
    );
  }

  @override
  SystemListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return SystemListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _SystemSearchBody<SystemSearchBloc> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, System) onTap,
    required bool allowNewButton,
  }) {
    return _SystemSearchBody<SystemSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class SystemLocalSearch extends ItemLocalSearch<System, SystemListManagerBloc> {
  const SystemLocalSearch({
    Key? key,
    required super.items,
  }) : super(key: key);

  @override
  SystemListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return SystemListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _SystemSearchBody<ItemLocalSearchBloc<System>> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, System) onTap,
    required bool allowNewButton,
  }) {
    return _SystemSearchBody<ItemLocalSearchBloc<System>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _SystemSearchBody<K extends ItemSearchBloc<System>>
    extends ItemSearchBody<System, K, SystemListManagerBloc> {
  const _SystemSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).systemString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).systemsString;

  @override
  System createItem(String query) => System(
        id: -1,
        name: query,
        iconURL: null,
        iconFilename: null,
        generation: 0,
        manufacturer: null,
      );

  @override
  Widget cardBuilder(BuildContext context, System item) =>
      SystemTheme.itemCard(context, item, onTap);
}
