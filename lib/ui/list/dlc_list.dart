import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class DLCAppBar extends ItemAppBar<DLC, DLCListBloc> {

  @override
  final Color themeColor = DLCTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).dlcsString;

  @override
  List<String> views(BuildContext context) => DLCTheme.views(context);

}

class DLCFAB extends ItemFAB<DLC, DLCListManagerBloc> {

  @override
  final Color themeColor = DLCTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).dlcString;

}

class DLCList extends ItemList<DLC, DLCListBloc, DLCListManagerBloc> {

  @override
  final String detailRouteName = dlcDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).dlcString;

  @override
  _DLCListBody itemListBodyBuilder({@required List<DLC> items, @required int viewIndex, @required void Function(DLC) onDelete, @required ListStyle style}) {

    return _DLCListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _DLCListBody extends ItemListBody<DLC, DLCListBloc> {

  _DLCListBody({
    Key key,
    @required List<DLC> items,
    @required int viewIndex,
    @required void Function(DLC) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  final String detailRouteName = dlcDetailRoute;

  @override
  final String localSearchRouteName = dlcLocalSearchRoute;

  @override
  final String statisticsRouteName = '';

  @override
  void Function() onStatisticsTap(BuildContext context) {

    return null;

  }

  @override
  String viewTitle(BuildContext context) {

    return DLCTheme.views(context).elementAt(viewIndex);

  }

}