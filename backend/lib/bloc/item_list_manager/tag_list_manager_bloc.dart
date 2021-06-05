import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_list_manager.dart';


class TagListManagerBloc extends ItemListManagerBloc<Tag> {
  TagListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag?> createFuture(AddItem<Tag> event) {

    return iCollectionRepository.createGameTag(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return iCollectionRepository.deleteGameTagById(event.item.id);

  }
}