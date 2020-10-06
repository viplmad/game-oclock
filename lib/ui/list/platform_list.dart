import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class PlatformAppBar extends ItemAppBar<Platform, PlatformListBloc> {

  @override
  BarData barData = platformBarData;

}

class PlatformFAB extends ItemFAB<Platform, PlatformListManagerBloc> {

  @override
  BarData barData = platformBarData;

}

class PlatformList extends ItemList<Platform, PlatformListBloc, PlatformListManagerBloc> {

  @override
  String detailRouteName = platformDetailRoute;

  @override
  _PlatformListBody itemListBodyBuilder({@required List<Platform> items, @required int viewIndex, @required void Function(Platform) onDelete, @required ListStyle style}) {

    return _PlatformListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _PlatformListBody extends ItemListBody<Platform, PlatformListBloc> {

  _PlatformListBody({
    Key key,
    @required List<Platform> items,
    @required int viewIndex,
    @required void Function(Platform) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  String detailRouteName = platformDetailRoute;

  @override
  String localSearchRouteName = platformLocalSearchRoute;

  @override
  void Function() onStatisticsTap(BuildContext context) {

    return null;

  }

  @override
  String getViewTitle() {

    return platformBarData.views.elementAt(viewIndex);

  }

}