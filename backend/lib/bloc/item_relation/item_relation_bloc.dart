import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


abstract class ItemRelationBloc<T extends Item, ID extends Object, W extends Item> extends Bloc<ItemRelationEvent, ItemRelationState> {
  ItemRelationBloc({
    required this.id,
    required this.managerBloc,
  }) : super(ItemRelationLoading()) {

    managerSubscription = managerBloc.stream.listen(mapRelationManagerStateToEvent);

  }

  final ID id;
  final ItemRelationManagerBloc<T, ID, W> managerBloc;
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

  Stream<ItemRelationState> _mapLoadToState() async* {

    yield ItemRelationLoading();

    try {

      final List<W> items = await getRelationStream();
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

      final int listItemIndex = items.indexWhere((W item) => item == event.item);
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
          .where((W item) => item != managerState.otherItem)
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
  Future<List<W>> getRelationStream() {

    return Future<List<W>>.error('Relation does not exist');

  }
}