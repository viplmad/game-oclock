import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType> {

  TypeListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<PurchaseType>> getReadAllStream() {

    return collectionRepository.getAllTypes();

  }

  @override
  Future<PurchaseType> createFuture(AddItem event) {

    return collectionRepository.insertType(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<PurchaseType> event) {

    return collectionRepository.deleteType(event.item.ID);

  }

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    TypeView typeView = TypeView.values[event.viewIndex];

    return collectionRepository.getTypesWithView(typeView);

  }

}