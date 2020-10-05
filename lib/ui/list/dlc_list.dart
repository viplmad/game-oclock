import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class DLCAppBar extends ItemAppBar<DLC, DLCListBloc> {

  @override
  BarData barData = dlcBarData;

}

class DLCFAB extends ItemFAB<DLC, DLCListManagerBloc> {

  @override
  BarData barData = dlcBarData;

}

class DLCList extends ItemList<DLC, DLCListBloc, DLCListManagerBloc> {

  @override
  String detailRouteName = dlcDetailRoute;

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

class _DLCListBody extends ItemListBody<DLC> {

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
  String detailRouteName = dlcDetailRoute;

  @override
  String localSearchRouteName = dlcLocalSearchRoute;

  @override
  void Function() onStatisticsTap(BuildContext context) {

    return null;

  }

  @override
  String getViewTitle() {

    return dlcBarData.views.elementAt(viewIndex);

  }

}