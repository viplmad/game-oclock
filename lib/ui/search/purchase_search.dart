import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PurchaseTheme;
import 'search.dart';

class PurchaseSearch
    extends ItemSearch<Purchase, PurchaseSearchBloc, PurchaseListManagerBloc> {
  const PurchaseSearch({
    Key? key,
    required super.onTapReturn,
    required super.viewIndex,
    this.viewYear,
  }) : super(
          key: key,
          detailRouteName: purchaseDetailRoute,
        );

  final int? viewYear;

  @override
  PurchaseSearchBloc searchBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PurchaseSearchBloc(
      collectionRepository: collectionRepository,
      viewIndex: viewIndex,
      viewYear: viewYear,
    );
  }

  @override
  PurchaseListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PurchaseListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseSearchBody<PurchaseSearchBloc> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Purchase) onTap,
    required bool allowNewButton,
  }) {
    return _PurchaseSearchBody<PurchaseSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class PurchaseLocalSearch
    extends ItemLocalSearch<Purchase, PurchaseListManagerBloc> {
  const PurchaseLocalSearch({
    Key? key,
    required super.items,
  }) : super(
          key: key,
          detailRouteName: purchaseDetailRoute,
        );

  @override
  PurchaseListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PurchaseListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseSearchBody<ItemLocalSearchBloc<Purchase>> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Purchase) onTap,
    required bool allowNewButton,
  }) {
    return _PurchaseSearchBody<ItemLocalSearchBloc<Purchase>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _PurchaseSearchBody<K extends ItemSearchBloc<Purchase>>
    extends ItemSearchBody<Purchase, K, PurchaseListManagerBloc> {
  const _PurchaseSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchaseString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).purchasesString;

  @override
  Purchase createItem(String query) => Purchase(
        id: -1,
        description: query,
        price: 0.0,
        externalCredit: 0.0,
        date: null,
        originalPrice: 0.0,
        store: null,
      );

  @override
  Widget cardBuilder(BuildContext context, Purchase item) =>
      PurchaseTheme.itemCard(context, item, onTap);
}
