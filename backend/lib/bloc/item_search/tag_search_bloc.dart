import 'package:backend/model/model.dart' show Tag, TagView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_search.dart';


class TagSearchBloc extends ItemRemoteSearchBloc<Tag, GameTagRepository> {
  TagSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);

  @override
  Future<List<Tag>> getInitialItems() {

    return repository.findAllGameTagsWithView(TagView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Tag>> getSearchItems(String query) {

    return repository.findAllGameTagsByName(query, super.maxResults).first;

  }
}