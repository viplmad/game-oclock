import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


abstract class RelationManagerBloc<T extends CollectionItem, O> extends Bloc<RelationManagerEvent, RelationManagerState> {
  RelationManagerBloc({
    @required this.itemId,
    @required this.iCollectionRepository,
  }) : super(Init());

  final int itemId;
  final ICollectionRepository iCollectionRepository;

  @override
  Stream<RelationManagerState> mapEventToState(RelationManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddRelation<O>) {

    yield* _mapAddRelationToState(event);

    } else if(event is DeleteRelation<O>) {

    yield* _mapDeleteRelationToState(event);

    }

    yield Init();

  }

  Stream<RelationManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<RelationManagerState> _mapAddRelationToState(AddRelation<O> event) async* {

    try{

      await addRelationFuture(event);
      yield RelationAdded<O>(event.otherItem);

    } catch(e) {

      yield RelationNotAdded(e.toString());

    }

  }

  Stream<RelationManagerState> _mapDeleteRelationToState(DeleteRelation<O> event) async* {

    try{

      await deleteRelationFuture(event);
      yield RelationDeleted<O>(event.otherItem);

    } catch(e) {

      yield RelationNotDeleted(e.toString());

    }

  }

  Future<dynamic> addRelationFuture(AddRelation<O> event) {

    return Future.error("Relation does not exist");

  }
  Future<dynamic> deleteRelationFuture(DeleteRelation<O> event) {

    return Future.error("Relation does not exist");

  }
}