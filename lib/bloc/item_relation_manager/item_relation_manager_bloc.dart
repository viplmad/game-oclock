import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


abstract class ItemRelationManagerBloc<T extends CollectionItem, W extends CollectionItem> extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    @required this.itemId,
    @required this.iCollectionRepository,
  }) : super(Initialised());

  final int itemId;
  final ICollectionRepository iCollectionRepository;

  @override
  Stream<ItemRelationManagerState> mapEventToState(ItemRelationManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddItemRelation<W>) {

    yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation<W>) {

    yield* _mapDeleteRelationToState(event);

    }

    yield Initialised();

  }

  Stream<ItemRelationManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
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
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    return Future.error("Relation does not exist");

  }
  @mustCallSuper
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    return Future.error("Relation does not exist");

  }
}