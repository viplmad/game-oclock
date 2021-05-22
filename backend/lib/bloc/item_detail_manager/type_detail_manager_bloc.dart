import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class TypeDetailManagerBloc extends ItemDetailManagerBloc<PurchaseType, PurchaseTypeUpdateProperties> {
  TypeDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<PurchaseType?> updateFuture(UpdateItemField<PurchaseType, PurchaseTypeUpdateProperties> event) {

    return iCollectionRepository.updatePurchaseType(event.item, event.updatedItem, event.updateProperties);

  }
}