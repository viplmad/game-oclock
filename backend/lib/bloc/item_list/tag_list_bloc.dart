import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:backend/service/service.dart'
    show TagService, GameCollectionService;

import 'item_list.dart';

class TagListBloc extends ItemListBloc<TagDTO, NewTagDTO, TagService> {
  TagListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.tagService);
}
