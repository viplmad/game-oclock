import 'package:backend/entity/entity.dart'
    show GameTagEntity, GameTagID, GameTagView;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameTagRepository;

import 'item_search.dart';

class GameTagSearchBloc extends ItemRemoteSearchBloc<GameTag, GameTagEntity,
    GameTagID, GameTagRepository> {
  GameTagSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
  }) : super(
          repository: collectionRepository.gameTagRepository,
          viewIndex: viewIndex,
        );

  @override
  Future<List<GameTag>> getInitialItems() {
    final GameTagView view = viewIndex != null
        ? GameTagView.values[viewIndex!]
        : GameTagView.lastCreated;
    final Future<List<GameTagEntity>> entityListFuture =
        repository.findFirstWithView(view, super.maxSuggestions);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);
  }

  @override
  Future<List<GameTag>> getSearchItems(String query) {
    if (viewIndex != null) {
      final GameTagView view = GameTagView.values[viewIndex!];
      final Future<List<GameTagEntity>> entityListFuture =
          repository.findFirstWithViewByName(view, query, super.maxResults);
      return GameTagMapper.futureEntityListToModelList(entityListFuture);
    } else {
      final Future<List<GameTagEntity>> entityListFuture =
          repository.findFirstByName(query, super.maxResults);
      return GameTagMapper.futureEntityListToModelList(entityListFuture);
    }
  }
}
