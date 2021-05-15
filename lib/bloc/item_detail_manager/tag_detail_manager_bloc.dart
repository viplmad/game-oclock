import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class TagDetailManagerBloc extends ItemDetailManagerBloc<Tag, GameTagUpdateProperties> {
  TagDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag?> updateFuture(UpdateItemField<Tag, GameTagUpdateProperties> event) {

    return iCollectionRepository.updateGameTag(event.item, event.updatedItem, event.updateProperties);

  }
}