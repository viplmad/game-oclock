import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


abstract class RelationBloc<T extends CollectionItem, O extends Object> extends Bloc<RelationEvent, RelationState> {
  RelationBloc({
    required this.itemId,
    required this.iCollectionRepository,
    required this.managerBloc,
  }) : super(RelationLoading()) {

    managerSubscription = managerBloc.stream.listen(mapRelationManagerStateToEvent);

  }

  final int itemId;
  final ICollectionRepository iCollectionRepository;
  final RelationManagerBloc<T, O> managerBloc;
  late StreamSubscription<RelationManagerState> managerSubscription;

  @override
  Stream<RelationState> mapEventToState(RelationEvent event) async* {

    yield* _checkConnection();

    if(event is LoadRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateElementRelation<O>) {

      yield* _mapUpdateRelationToState(event);

    } else if(event is UpdateRelationElement<O>) {

      yield* _mapUpdateItemToState(event);

    }

  }

  Stream<RelationState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield const RelationNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch (e) {

        yield RelationNotLoaded(e.toString());

      }
    }

  }

  Stream<RelationState> _mapLoadToState() async* {

    yield RelationLoading();

    try {

      final List<O> items = await getRelationStream().first;
      yield RelationLoaded<O>(items);

    } catch (e) {

      yield RelationNotLoaded(e.toString());

    }

  }

  Stream<RelationState> _mapUpdateRelationToState(UpdateElementRelation<O> event) async* {

    yield RelationLoaded<O>(event.otherItems);

  }

  Stream<RelationState> _mapUpdateItemToState(UpdateRelationElement<O> event) async* {

    if(state is RelationLoaded<O>) {
      final List<O> items = List<O>.from((state as RelationLoaded<O>).otherItems);

      final int listItemIndex = items.indexWhere((O element) => element == event.oldItem);
      final O listItem = items.elementAt(listItemIndex);

      if(listItem != event.item) {
        items[listItemIndex] = event.item;

        yield RelationLoaded<O>(items);
      }

    }

  }

  void mapRelationManagerStateToEvent(RelationManagerState managerState) {

    if(managerState is RelationAdded<O>) {

      _mapAddedToEvent(managerState);

    } else if(managerState is RelationDeleted<O>) {

      _mapDeletedToEvent(managerState);

    }

  }

  void _mapAddedToEvent(RelationAdded<O> managerState) {

    if(state is RelationLoaded<O>) {
      final List<O> items = (state as RelationLoaded<O>).otherItems;

      final List<O> updatedItems = List<O>.from(items)..add(managerState.otherItem);

      add(UpdateElementRelation<O>(updatedItems..sort()));
    }

  }

  void _mapDeletedToEvent(RelationDeleted<O> managerState) {

    if(state is RelationLoaded<O>) {
      final List<O> items = (state as RelationLoaded<O>).otherItems;

      final List<O> updatedItems = items
          .where((O element) => element != managerState.otherItem)
          .toList(growable: false);

      add(UpdateElementRelation<O>(updatedItems));
    }

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

  Stream<List<O>> getRelationStream() {

    return Stream<List<O>>.error('Relation does not exist');

  }
}