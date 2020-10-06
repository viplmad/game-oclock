import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform> {

  PlatformDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required PlatformDetailManagerBloc managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Platform> getReadStream() {

    return iCollectionRepository.getPlatformWithID(itemID);

  }

}