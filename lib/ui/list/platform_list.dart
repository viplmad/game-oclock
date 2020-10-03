import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import '../theme/theme.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';

import 'list.dart';


class PlatformAppBar extends ItemAppBar<Platform, PlatformListBloc> {

  @override
  BarData getBarData() {

    return platformBarData;

  }

}

class PlatformFAB extends ItemFAB<Platform, PlatformListBloc> {

  @override
  BarData getBarData() {

    return platformBarData;

  }

}

class PlatformList extends ItemList<Platform, PlatformListBloc> {

  @override
  ItemDetail<Platform, PlatformDetailBloc> detailBuilder(Platform platform) {

    return PlatformDetail(
      item: platform,
    );

  }

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

class _PlatformListBody extends ItemListBody<Platform> {

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
  String getViewTitle() {

    return platformBarData.views.elementAt(viewIndex);

  }

  @override
  ItemDetail<Platform, PlatformDetailBloc> detailBuilder(Platform platform) {

    return PlatformDetail(
      item: platform,
    );

  }

  @override
  Widget statisticsBuilder() {

    return null;

  }

}