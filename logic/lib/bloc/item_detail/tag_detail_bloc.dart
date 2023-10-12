import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart' show GameOClockService, TagService;

import 'item_detail.dart';

class TagDetailBloc extends ItemDetailBloc<TagDTO, NewTagDTO, TagService> {
  TagDetailBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(
          service: collectionService.tagService,
        );
}
