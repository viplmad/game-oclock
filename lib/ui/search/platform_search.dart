import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'search.dart';

class PlatformSearch extends ItemSearch<PlatformDTO, NewPlatformDTO,
    PlatformSearchBloc, PlatformListManagerBloc> {
  const PlatformSearch({
    Key? key,
    required super.onTapReturn,
  }) : super(
          key: key,
          detailRouteName: platformDetailRoute,
        );

  @override
  PlatformSearchBloc searchBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return PlatformSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  PlatformListManagerBloc managerBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return PlatformListManagerBloc(
      collectionService: collectionService,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _PlatformSearchBody itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, PlatformDTO) onTap,
    required bool allowNewButton,
  }) {
    return _PlatformSearchBody(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _PlatformSearchBody extends ItemSearchBody<PlatformDTO, NewPlatformDTO,
    PlatformSearchBloc, PlatformListManagerBloc> {
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
  NewPlatformDTO createItem(String query) => NewPlatformDTO(name: query);

  @override
  Widget cardBuilder(BuildContext context, PlatformDTO item) =>
      PlatformTheme.itemCard(context, item, onTap);
}
