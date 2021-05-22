import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

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