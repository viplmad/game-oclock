import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme;
import 'search.dart';

class DLCSearch
    extends ItemSearch<DLCDTO, NewDLCDTO, DLCSearchBloc, DLCListManagerBloc> {
  const DLCSearch({
    Key? key,
    required super.onTapReturn,
  }) : super(
          key: key,
          detailRouteName: dlcDetailRoute,
        );

  @override
  DLCSearchBloc searchBlocBuilder(
    GameOClockService collectionService,
  ) {
    return DLCSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  DLCListManagerBloc managerBlocBuilder(
    GameOClockService collectionService,
  ) {
    return DLCListManagerBloc(
      collectionService: collectionService,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _DLCSearchBody itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, DLCDTO) onTap,
    required bool allowNewButton,
  }) {
    return _DLCSearchBody(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _DLCSearchBody extends ItemSearchBody<DLCDTO, NewDLCDTO, DLCSearchBloc,
    DLCListManagerBloc> {
  const _DLCSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.dlcsString;

  @override
  NewDLCDTO createItem(String query) => NewDLCDTO(name: query);

  @override
  Widget cardBuilder(BuildContext context, DLCDTO item) =>
      DLCTheme.itemCard(context, item, onTap);
}
