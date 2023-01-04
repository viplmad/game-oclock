import 'package:game_collection_client/api.dart' show TagDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, TagService;
import 'package:backend/model/model.dart' show TagView;

import 'item_search.dart';

class TagSearchBloc extends ItemSearchBloc<TagDTO, TagService> {
  TagSearchBloc({
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.tagService,
          initialViewIndex: TagView.lastUpdated.index,
        );
}
