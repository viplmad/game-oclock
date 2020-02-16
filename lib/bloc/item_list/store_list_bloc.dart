import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class StoreListBloc extends ItemListBloc {

  StoreListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Store>> getReadAllStream() {

    return collectionRepository.getAllStores();

  }

  @override
  Stream<List<Store>> getReadViewStream(UpdateView event) {

    int viewIndex = storeViews.indexOf(event.view);
    StoreView storeView = StoreView.values[viewIndex];

    return collectionRepository.getStoresWithView(storeView);

  }

}