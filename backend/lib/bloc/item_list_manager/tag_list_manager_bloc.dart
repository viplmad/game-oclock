import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart'
    show TagService, GameCollectionService;

import 'item_list_manager.dart';

class TagListManagerBloc
    extends ItemListManagerBloc<TagDTO, NewTagDTO, TagService> {
  TagListManagerBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.tagService);
}
