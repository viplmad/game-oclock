import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<Tag> {

  TagDetailBloc({
    @required int tagID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: tagID, collectionRepository: collectionRepository);

  @override
  Stream<Tag> getReadStream() {

    return collectionRepository.getTagWithID(itemID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField<Tag> event) {

    return collectionRepository.updateTag(itemID, event.field, event.value);

  }

}