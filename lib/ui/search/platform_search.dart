import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show PlatformDTO, NewPlatformDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

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
    GameOClockService collectionService,
  ) {
    return PlatformSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  PlatformListManagerBloc managerBlocBuilder(
    GameOClockService collectionService,
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
      AppLocalizations.of(context)!.platformString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.platformsString;

  @override
  NewPlatformDTO createItem(String query) => NewPlatformDTO(name: query);

  @override
  Widget cardBuilder(BuildContext context, PlatformDTO item) =>
      PlatformTheme.itemCard(context, item, onTap);
}
