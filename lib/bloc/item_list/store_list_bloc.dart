import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class StoreListBloc extends ItemListBloc<Store> {

  StoreListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Store>> getReadAllStream() {

    return collectionRepository.getAllStores();

  }

  @override
  Future<Store> createFuture(AddItem event) {

    return collectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    return collectionRepository.deleteStore(event.item.ID);

  }

  @override
  Stream<List<Store>> getReadViewStream(UpdateView event) {

    StoreView storeView = StoreView.values[event.viewIndex];

    return collectionRepository.getStoresWithView(storeView);

  }

}