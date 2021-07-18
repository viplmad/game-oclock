import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/repository/item_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


abstract class ItemRelationBloc<T extends Item, W extends Item> extends Bloc<ItemRelationEvent, ItemRelationState> {
  ItemRelationBloc({
    required this.itemId,
    required this.managerBloc,
  }) : super(ItemRelationLoading()) {

    managerSubscription = managerBloc.stream.listen(mapRelationManagerStateToEvent);

  }

  final int itemId;
  final ItemRelationManagerBloc<T, W> managerBloc;
  late StreamSubscription<ItemRelationManagerState> managerSubscription;

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    //yield* _checkConnection(); // TODO

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation<W>) {

      yield* _mapUpdateRelationToState(event);

    } else if(event is UpdateRelationItem<W>) {

      yield* _mapUpdateItemToState(event);

    }

  }

  /*Stream<ItemRelationState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield const ItemRelationNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch (e) {

        yield ItemRelationNotLoaded(e.toString());

      }
    }

  }*/

  Stream<ItemRelationState> _mapLoadToState() async* {

    yield ItemRelationLoading();

    try {

      final List<W> items = await getRelationStream().first;
      yield ItemRelationLoaded<W>(items);

    } catch (e) {

      yield ItemRelationNotLoaded(e.toString());

    }

  }

  Stream<ItemRelationState> _mapUpdateRelationToState(UpdateItemRelation<W> event) async* {

    yield ItemRelationLoaded<W>(event.otherItems);

  }

  Stream<ItemRelationState> _mapUpdateItemToState(UpdateRelationItem<W> event) async* {

    if(state is ItemRelationLoaded<W>) {
      final List<W> items = List<W>.from((state as ItemRelationLoaded<W>).otherItems);

      final int listItemIndex = items.indexWhere((W item) => item.id == event.item.id);
      final W listItem = items.elementAt(listItemIndex);

      if(listItem != event.item) {
        items[listItemIndex] = event.item;

        yield ItemRelationLoaded<W>(items);
      }

    }

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
      final List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = List<W>.from(items)..add(managerState.otherItem);

      add(UpdateItemRelation<W>(updatedItems));
    }

  }

  void _mapDeletedToEvent(ItemRelationDeleted<W> managerState) {

    if(state is ItemRelationLoaded<W>) {
      final List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = items
          .where((W item) => item.id != managerState.otherItem.id)
          .toList(growable: false);

      add(UpdateItemRelation<W>(updatedItems));
    }

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

  @mustCallSuper
  Stream<List<W>> getRelationStream() {

    return Stream<List<W>>.error('Relation does not exist');

  }
}