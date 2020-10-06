import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<Tag> {

  TagDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<Tag> getReadStream() {

    return iCollectionRepository.getTagWithID(itemID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField<Tag> event) {

    return iCollectionRepository.updateTag(itemID, event.field, event.value);

  }

}