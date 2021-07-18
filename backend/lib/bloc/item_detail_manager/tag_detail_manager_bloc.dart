import 'package:backend/model/model.dart' show Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_detail_manager.dart';


class TagDetailManagerBloc extends ItemDetailManagerBloc<Tag, GameTagRepository> {
  TagDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.gameTagRepository);
}