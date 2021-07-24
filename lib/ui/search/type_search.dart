import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import 'search.dart';


class TypeSearch extends ItemSearch<PurchaseType, TypeSearchBloc, TypeListManagerBloc> {
  const TypeSearch({
    Key? key,
  }) : super(key: key);

  @override
  TypeSearchBloc searchBlocBuilder(GameCollectionRepository collectionRepository) {

    return TypeSearchBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  TypeListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return TypeListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _TypeSearchBody<TypeSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, PurchaseType) onTap, required bool allowNewButton}) {

    return _TypeSearchBody<TypeSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class TypeLocalSearch extends ItemLocalSearch<PurchaseType, TypeListManagerBloc> {
  const TypeLocalSearch({
    Key? key,
    required List<PurchaseType> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = '';

  @override
  void Function() onTap(BuildContext context, PurchaseType item) => () {};

  @override
  TypeListManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return TypeListManagerBloc(
      collectionRepository: collectionRepository,
    );

  }

  @override
  _TypeSearchBody<ItemLocalSearchBloc<PurchaseType>> itemSearchBodyBuilder({required void Function() Function(BuildContext, PurchaseType) onTap, required bool allowNewButton}) {

    return _TypeSearchBody<ItemLocalSearchBloc<PurchaseType>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _TypeSearchBody<K extends ItemSearchBloc<PurchaseType>> extends ItemSearchBody<PurchaseType, K, TypeListManagerBloc> {
  const _TypeSearchBody({
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
  Widget cardBuilder(BuildContext context, PurchaseType item) => TypeTheme.itemCard(context, item, onTap);
}