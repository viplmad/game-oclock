import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class StoreListBloc extends ItemListBloc<Store> {
  StoreListBloc({
    required ICollectionRepository iCollectionRepository,
    required StoreListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Store>> getReadAllStream() {

    return iCollectionRepository.findAllStores();

  }

  @override
  Stream<List<Store>> getReadViewStream(UpdateView event) {

    final StoreView storeView = StoreView.values[event.viewIndex];

    return iCollectionRepository.findAllStoresWithView(storeView);

  }
}