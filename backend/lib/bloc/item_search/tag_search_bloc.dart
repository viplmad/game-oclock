import 'package:game_collection_client/api.dart' show TagDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, TagService;

import 'item_search.dart';

class TagSearchBloc extends ItemSearchBloc<TagDTO, TagService> {
  TagSearchBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.tagService);
}
