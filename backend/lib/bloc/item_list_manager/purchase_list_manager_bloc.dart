import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class PurchaseListManagerBloc extends ItemListManagerBloc<Purchase> {
  PurchaseListManagerBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Purchase?> createFuture(AddItem<Purchase> event) {

    return iCollectionRepository.createPurchase(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    return iCollectionRepository.deletePurchaseById(event.item.id);

  }
}