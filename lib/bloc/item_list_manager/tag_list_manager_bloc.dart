import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class TagListManagerBloc extends ItemListManagerBloc<Tag> {

  TagListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return iCollectionRepository.createTag(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return iCollectionRepository.deleteTag(event.item.id);

  }

}