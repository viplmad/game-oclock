import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class TypeDetailManagerBloc extends ItemDetailManagerBloc<PurchaseType> {

  TypeDetailManagerBloc({
    @required int itemID,
    ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<PurchaseType> updateFuture(UpdateItemField<PurchaseType> event) {

    return iCollectionRepository.updateType(itemID, event.field, event.value);

  }

}