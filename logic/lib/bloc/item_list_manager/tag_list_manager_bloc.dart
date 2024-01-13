import 'package:game_oclock_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/service/service.dart' show TagService, GameOClockService;

import 'item_list_manager.dart';

class TagListManagerBloc
    extends ItemListManagerBloc<TagDTO, NewTagDTO, TagService> {
  TagListManagerBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.tagService);
}
