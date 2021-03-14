import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform> {
  PlatformDetailBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required PlatformDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Platform?> getReadStream() {

    return iCollectionRepository.getPlatformWithId(itemId);

  }
}