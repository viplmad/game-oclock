import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game, GameUpdateProperties> {
  GameDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required GameDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Game?> getReadStream() {

    return iCollectionRepository.findGameById(itemId);

  }
}