import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType> {

  TypeListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<PurchaseType>> getReadAllStream() {

    return iCollectionRepository.getAllTypes();

  }

  @override
  Future<PurchaseType> createFuture(AddItem event) {

    return iCollectionRepository.insertType(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<PurchaseType> event) {

    return iCollectionRepository.deleteType(event.item.ID);

  }

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    TypeView typeView = TypeView.values[event.viewIndex];

    return iCollectionRepository.getTypesWithView(typeView);

  }

}