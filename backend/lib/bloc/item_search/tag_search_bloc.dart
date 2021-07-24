import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID, TagView;
import 'package:backend/model/model.dart' show Tag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_search.dart';


class TagSearchBloc extends ItemRemoteSearchBloc<Tag, GameTagEntity, GameTagID, GameTagRepository> {
  TagSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);

  @override
  Future<List<Tag>> getInitialItems() {

    final Future<List<GameTagEntity>> entityListFuture = repository.findAllGameTagsWithView(TagView.LastCreated, super.maxSuggestions);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<Tag>> getSearchItems(String query) {

    final Future<List<GameTagEntity>> entityListFuture = repository.findAllGameTagsByName(query, super.maxResults);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }
}