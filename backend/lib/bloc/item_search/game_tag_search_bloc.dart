import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID, GameTagView;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_search.dart';


class GameTagSearchBloc extends ItemRemoteSearchBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  GameTagSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);

  @override
  Future<List<GameTag>> getInitialItems() {

    final Future<List<GameTagEntity>> entityListFuture = repository.findFirstWithView(GameTagView.lastCreated, super.maxSuggestions);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<GameTag>> getSearchItems(String query) {

    final Future<List<GameTagEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }
}