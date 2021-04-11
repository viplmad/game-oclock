import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

//import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class SystemSearch extends ItemSearch<System, SystemSearchBloc, SystemListManagerBloc> {
  const SystemSearch({
    Key? key,
  }) : super(key: key);

  @override
  SystemSearchBloc searchBlocBuilder() {

    return SystemSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  SystemListManagerBloc managerBlocBuilder() {

    return SystemListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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

class SystemLocalSearch extends ItemLocalSearch<System, SystemListManagerBloc> {
  const SystemLocalSearch({
    Key? key,
    required List<System> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = '';

  @override
  void Function() onTap(BuildContext context, System item) => () {};

  @override
  SystemListManagerBloc managerBlocBuilder() {

    return SystemListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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

class _SystemSearchBody<K extends ItemSearchBloc<System>> extends ItemSearchBody<System, K, SystemListManagerBloc> {
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
  Widget cardBuilder(BuildContext context, System item) => SystemTheme.itemCard(context, item, onTap);
}