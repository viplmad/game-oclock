import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class TagDetailManagerBloc extends ItemDetailManagerBloc<Tag> {

  TagDetailManagerBloc({
    @required int itemId,
    ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag> updateFuture(UpdateItemField<Tag> event) {

    return iCollectionRepository.updateTag(itemId, event.field, event.value);

  }

}