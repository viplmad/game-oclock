import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class PurchaseDetailManagerBloc extends ItemDetailManagerBloc<Purchase, PurchaseUpdateProperties> {
  PurchaseDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Purchase?> updateFuture(UpdateItemField<Purchase, PurchaseUpdateProperties> event) {

    return iCollectionRepository.updatePurchase(event.item, event.updatedItem, event.updateProperties);

  }
}