import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/entity.dart';
import 'package:game_collection/model/dlc.dart';

import 'entity_list.dart';


class DLCListBloc extends EntityListBloc {

  DLCListBloc({@required ICollectionRepository collectionRepository}) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<DLC>> getReadStream() {

    return collectionRepository.getAllDLCs();

  }

  @override
  Stream<dynamic> getCreateStream(Entity entity) {

    final DLC dlc = (entity as DLC);

    return collectionRepository.insertDLC('').asStream();

  }

  @override
  Stream getDeleteStream(Entity entity) {

    return collectionRepository.deleteDLC(entity.ID).asStream();

  }

}