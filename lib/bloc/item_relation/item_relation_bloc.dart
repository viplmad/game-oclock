import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


abstract class ItemRelationBloc<T extends CollectionItem, W extends CollectionItem> extends Bloc<ItemRelationEvent, ItemRelationState> {

  ItemRelationBloc({@required this.itemID, @required this.iCollectionRepository, @required this.managerBloc}) : super(ItemRelationLoading()) {

    managerSubscription = managerBloc.listen(mapRelationManagerStateToEvent);

  }

  final int itemID;
  final ICollectionRepository iCollectionRepository;
  final ItemRelationManagerBloc<T, W> managerBloc;
  StreamSubscription<ItemRelationManagerState> managerSubscription;

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation<W>) {

      yield* _mapUpdateRelationToState(event);

    }

  }

  Stream<ItemRelationState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield ItemRelationNotLoaded("Connection lost. Trying to reconnect");

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemRelationState> _mapLoadToState() async* {

    yield ItemRelationLoading();

    try {

      final List<W> items = await getRelationStream().first;
      yield ItemRelationLoaded<W>(
        items,
      );

    } catch (e) {

      yield ItemRelationNotLoaded(e.toString());

    }

  }

  Stream<ItemRelationState> _mapUpdateRelationToState(UpdateItemRelation<W> event) async* {

    yield ItemRelationLoaded<W>(
      event.otherItems,
    );

  }

  void mapRelationManagerStateToEvent(ItemRelationManagerState managerState) {

    if(managerState is ItemRelationAdded<W>) {

      _mapAddedToEvent(managerState);

    } else if(managerState is ItemRelationDeleted<W>) {

      _mapDeletedToEvent(managerState);

    }

  }

  void _mapAddedToEvent(ItemRelationAdded<W> managerState) {

    if(state is ItemRelationLoaded<W>) {
      List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = List.from(items)..add(managerState.otherItem);

      add(
          UpdateItemRelation<W>(
            updatedItems,
          )
      );
    }

  }

  void _mapDeletedToEvent(ItemRelationDeleted<W> managerState) {

    if(state is ItemRelationLoaded<W>) {
      List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = items
          .where((W item) => item.ID != managerState.otherItem.ID)
          .toList(growable: false);

      add(
          UpdateItemRelation<W>(
            updatedItems,
          )
      );
    }

  }

  @override
  Future<void> close() {

    managerSubscription?.cancel();
    return super.close();

  }

  @mustCallSuper
  Stream<List<W>> getRelationStream() {

    return Stream.error("Relation does not exist");

  }

}