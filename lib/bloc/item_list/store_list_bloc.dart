import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class StoreListBloc extends ItemListBloc<Store> {

  StoreListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<Store>> getReadAllStream() {

    return iCollectionRepository.getAllStores();

  }

  @override
  Future<Store> createFuture(AddItem event) {

    return iCollectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    return iCollectionRepository.deleteStore(event.item.ID);

  }

  @override
  Stream<List<Store>> getReadViewStream(UpdateView event) {

    StoreView storeView = StoreView.values[event.viewIndex];

    return iCollectionRepository.getStoresWithView(storeView);

  }

}