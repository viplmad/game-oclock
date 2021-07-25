import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show DLC;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme;
import 'search.dart';


class DLCSearch extends ItemSearch<DLC, DLCSearchBloc, DLCListManagerBloc> {
  const DLCSearch({
    Key? key,
  }) : super(key: key);

  @override
  DLCSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return DLCSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  DLCListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return DLCListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _DLCSearchBody<DLCSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, DLC) onTap, required bool allowNewButton}) {

    return _DLCSearchBody<DLCSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class DLCLocalSearch extends ItemLocalSearch<DLC, DLCListManagerBloc> {
  const DLCLocalSearch({
    Key? key,
    required List<DLC> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = dlcDetailRoute;

  @override DLCListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return DLCListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _DLCSearchBody<ItemLocalSearchBloc<DLC>> itemSearchBodyBuilder({required void Function() Function(BuildContext, DLC) onTap, required bool allowNewButton}) {

    return _DLCSearchBody<ItemLocalSearchBloc<DLC>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _DLCSearchBody<K extends ItemSearchBloc<DLC>> extends ItemSearchBody<DLC, K, DLCListManagerBloc> {
  const _DLCSearchBody({
    Key? key,
    required void Function() Function(BuildContext, DLC) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).dlcString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).dlcsString;

  @override
  DLC createItem(String query) => DLC(id: -1, name: query, releaseYear: null, coverURL: null, coverFilename: null, finishDate: null, baseGame: null);

  @override
  Widget cardBuilder(BuildContext context, DLC item) => DLCTheme.itemCard(context, item, onTap);
}