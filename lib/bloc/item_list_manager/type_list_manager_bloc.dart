import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class TypeListManagerBloc extends ItemListManagerBloc<PurchaseType> {
  TypeListManagerBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<PurchaseType?> createFuture(AddItem<PurchaseType> event) {

    return iCollectionRepository.createPurchaseType(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<PurchaseType> event) {

    return iCollectionRepository.deletePurchaseTypeById(event.item.id);

  }
}