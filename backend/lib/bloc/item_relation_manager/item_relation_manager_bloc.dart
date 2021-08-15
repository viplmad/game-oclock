import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'item_relation_manager.dart';


abstract class ItemRelationManagerBloc<T extends Item, ID extends Object, W extends Item> extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    required this.id,
    required this.collectionRepository,
  }) : super(ItemRelationManagerInitialised());

  final ID id;
  final GameCollectionRepository collectionRepository;

  @override
  Stream<ItemRelationManagerState> mapEventToState(ItemRelationManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddItemRelation<W>) {

    yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation<W>) {

    yield* _mapDeleteRelationToState(event);

    }

    yield ItemRelationManagerInitialised();

  }

  Stream<ItemRelationManagerState> _checkConnection() async* {

    if(collectionRepository.isClosed()) {

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch (e) {

        yield ItemRelationNotAdded(e.toString());

      }
    }

  }

  Stream<ItemRelationManagerState> _mapAddRelationToState(AddItemRelation<W> event) async* {

    try{

      await addRelationFuture(event);
      yield ItemRelationAdded<W>(event.otherItem);

    } catch(e) {

      yield ItemRelationNotAdded(e.toString());

    }

  }

  Stream<ItemRelationManagerState> _mapDeleteRelationToState(DeleteItemRelation<W> event) async* {

    try{

      await deleteRelationFuture(event);
      yield ItemRelationDeleted<W>(event.otherItem);

    } catch(e) {

      yield ItemRelationNotDeleted(e.toString());

    }

  }

  @mustCallSuper
  Future<Object?> addRelationFuture(AddItemRelation<W> event) {

    return Future<Object?>.error('Relation does not exist');

  }
  @mustCallSuper
  Future<Object?> deleteRelationFuture(DeleteItemRelation<W> event) {

    return Future<Object?>.error('Relation does not exist');

  }
}