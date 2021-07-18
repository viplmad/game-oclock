import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart';

import 'item_relation_manager.dart';


abstract class ItemRelationManagerBloc<T extends Item, W extends Item> extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    required this.itemId,
  }) : super(ItemRelationManagerInitialised());

  final int itemId;

  @override
  Stream<ItemRelationManagerState> mapEventToState(ItemRelationManagerEvent event) async* {

    //yield* _checkConnection(); // TODO

    if(event is AddItemRelation<W>) {

    yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation<W>) {

    yield* _mapDeleteRelationToState(event);

    }

    yield ItemRelationManagerInitialised();

  }

  /*Stream<ItemRelationManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch (e) {

        yield ItemRelationNotAdded(e.toString());

      }
    }

  }*/

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
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    return Future<dynamic>.error('Relation does not exist');

  }
  @mustCallSuper
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    return Future<dynamic>.error('Relation does not exist');

  }
}