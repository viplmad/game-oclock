import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<Tag, Object> {
  TagDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required TagDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Tag?> getReadStream() {

    return iCollectionRepository.findGameTagById(itemId);

  }
}