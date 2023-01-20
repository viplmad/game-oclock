import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, TagService;

import 'item_detail.dart';

class TagDetailBloc extends ItemDetailBloc<TagDTO, NewTagDTO, TagService> {
  TagDetailBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(
          service: collectionService.tagService,
        );
}
