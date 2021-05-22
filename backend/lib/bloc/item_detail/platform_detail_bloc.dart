import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform, PlatformUpdateProperties> {
  PlatformDetailBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required PlatformDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Platform?> getReadStream() {

    return iCollectionRepository.findPlatformById(itemId);

  }
}