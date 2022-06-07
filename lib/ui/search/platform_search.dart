import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Platform;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'search.dart';

class PlatformSearch
    extends ItemSearch<Platform, PlatformSearchBloc, PlatformListManagerBloc> {
  const PlatformSearch({
    Key? key,
    required super.onTapReturn,
    required super.viewIndex,
  }) : super(
          key: key,
          detailRouteName: platformDetailRoute,
        );

  @override
  PlatformSearchBloc searchBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PlatformSearchBloc(
      collectionRepository: collectionRepository,
      viewIndex: viewIndex,
    );
  }

  @override
  PlatformListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PlatformListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _PlatformSearchBody<PlatformSearchBloc> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Platform) onTap,
    required bool allowNewButton,
  }) {
    return _PlatformSearchBody<PlatformSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class PlatformLocalSearch
    extends ItemLocalSearch<Platform, PlatformListManagerBloc> {
  const PlatformLocalSearch({
    Key? key,
    required super.items,
  }) : super(
          key: key,
          detailRouteName: platformDetailRoute,
        );

  @override
  PlatformListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PlatformListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _PlatformSearchBody<ItemLocalSearchBloc<Platform>> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Platform) onTap,
    required bool allowNewButton,
  }) {
    return _PlatformSearchBody<ItemLocalSearchBloc<Platform>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _PlatformSearchBody<K extends ItemSearchBloc<Platform>>
    extends ItemSearchBody<Platform, K, PlatformListManagerBloc> {
  const _PlatformSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).platformsString;

  @override
  Platform createItem(String query) => Platform(
        id: -1,
        name: query,
        iconURL: null,
        iconFilename: null,
        type: null,
      );

  @override
  Widget cardBuilder(BuildContext context, Platform item) =>
      PlatformTheme.itemCard(context, item, onTap);
}
