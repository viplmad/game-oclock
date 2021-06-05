import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_detail_manager.dart';


class TagDetailManagerBloc extends ItemDetailManagerBloc<Tag, GameTagUpdateProperties> {
  TagDetailManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag?> updateFuture(UpdateItemField<Tag, GameTagUpdateProperties> event) {

    return iCollectionRepository.updateGameTag(event.item, event.updatedItem, event.updateProperties);

  }
}