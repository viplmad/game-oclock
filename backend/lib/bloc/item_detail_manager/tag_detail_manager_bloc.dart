import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, TagService;

import 'item_detail_manager.dart';

class TagDetailManagerBloc
    extends ItemDetailManagerBloc<TagDTO, NewTagDTO, TagService> {
  TagDetailManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.tagService,
        );
}
