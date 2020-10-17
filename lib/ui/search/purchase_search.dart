import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class PurchaseSearch extends ItemSearch<Purchase, PurchaseSearchBloc, PurchaseListManagerBloc> {

  @override
  PurchaseSearchBloc searchBlocBuilder() {

    return PurchaseSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  PurchaseListManagerBloc managerBlocBuilder() {

    return PurchaseListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _PurchaseSearchBody<PurchaseSearchBloc> itemSearchBodyBuilder({void Function() Function(BuildContext, Purchase) onTap, bool allowNewButton}) {

    return _PurchaseSearchBody<PurchaseSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }

}

class PurchaseLocalSearch extends ItemLocalSearch<Purchase, PurchaseListManagerBloc> {

  PurchaseLocalSearch({
    Key key,
    @required List<Purchase> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  PurchaseListManagerBloc managerBlocBuilder() {

    return PurchaseListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _PurchaseSearchBody<ItemLocalSearchBloc<Purchase>> itemSearchBodyBuilder({void Function() Function(BuildContext, Purchase) onTap, bool allowNewButton}) {

    return _PurchaseSearchBody<ItemLocalSearchBloc<Purchase>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }

}

class _PurchaseSearchBody<K extends ItemSearchBloc<Purchase>> extends ItemSearchBody<Purchase, K, PurchaseListManagerBloc> {
  const _PurchaseSearchBody({Key key, @required void Function() Function(BuildContext, Purchase) onTap, bool allowNewButton = false}) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).purchaseString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchasesString;

  @override
  Widget cardBuilder(BuildContext context, Purchase item) {

    return PurchaseTheme.itemCard(context, item, onTap);

  }

}