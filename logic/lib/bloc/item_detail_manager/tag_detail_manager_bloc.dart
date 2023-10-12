import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart' show GameOClockService, TagService;

import 'item_detail_manager.dart';

class TagDetailManagerBloc
    extends ItemDetailManagerBloc<TagDTO, NewTagDTO, TagService> {
  TagDetailManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  }) : super(
          service: collectionService.tagService,
        );
}
