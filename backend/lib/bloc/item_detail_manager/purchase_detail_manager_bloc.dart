import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_detail_manager.dart';


class PurchaseDetailManagerBloc extends ItemDetailManagerBloc<Purchase, PurchaseUpdateProperties> {
  PurchaseDetailManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Purchase?> updateFuture(UpdateItemField<Purchase, PurchaseUpdateProperties> event) {

    return iCollectionRepository.updatePurchase(event.item, event.updatedItem, event.updateProperties);

  }
}