import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class PurchaseListManagerBloc extends ItemListManagerBloc<Purchase> {
  PurchaseListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Purchase> createFuture(AddItem event) {

    return iCollectionRepository.createPurchase(event.title?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    return iCollectionRepository.deletePurchase(event.item.id);

  }
}