import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart' show PurchaseTypeTheme;
import 'search.dart';


class PurchaseTypeSearch extends ItemSearch<PurchaseType, PurchaseTypeSearchBloc, PurchaseTypeListManagerBloc> {
  const PurchaseTypeSearch({
    Key? key,
  }) : super(key: key);

  @override
  PurchaseTypeSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return PurchaseTypeSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  PurchaseTypeListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return PurchaseTypeListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _PurchaseTypeSearchBody<PurchaseTypeSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, PurchaseType) onTap, required bool allowNewButton}) {

    return _PurchaseTypeSearchBody<PurchaseTypeSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class PurchaseTypeLocalSearch extends ItemLocalSearch<PurchaseType, PurchaseTypeListManagerBloc> {
  const PurchaseTypeLocalSearch({
    Key? key,
    required List<PurchaseType> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, PurchaseType item) => () {};

  @override
  PurchaseTypeListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return PurchaseTypeListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _PurchaseTypeSearchBody<ItemLocalSearchBloc<PurchaseType>> itemSearchBodyBuilder({required void Function() Function(BuildContext, PurchaseType) onTap, required bool allowNewButton}) {

    return _PurchaseTypeSearchBody<ItemLocalSearchBloc<PurchaseType>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _PurchaseTypeSearchBody<K extends ItemSearchBloc<PurchaseType>> extends ItemSearchBody<PurchaseType, K, PurchaseTypeListManagerBloc> {
  const _PurchaseTypeSearchBody({
    Key? key,
    required void Function() Function(BuildContext, PurchaseType) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseTypeString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseTypeString;

  @override
  PurchaseType createItem(String query) => PurchaseType(id: -1, name: query);

  @override
  Widget cardBuilder(BuildContext context, PurchaseType item) => PurchaseTypeTheme.itemCard(context, item, onTap);
}