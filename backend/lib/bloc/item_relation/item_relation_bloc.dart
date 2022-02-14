import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import '../bloc_utils.dart';
import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

abstract class ItemRelationBloc<T extends Item, ID extends Object,
    W extends Item> extends Bloc<ItemRelationEvent, ItemRelationState> {
  ItemRelationBloc({
    required this.id,
    required this.collectionRepository,
    required this.managerBloc,
  }) : super(ItemRelationLoading()) {
    on<LoadItemRelation>(_mapLoadToState);
    on<UpdateItemRelation<W>>(_mapUpdateRelationToState);
    on<UpdateRelationItem<W>>(_mapUpdateItemToState);

    managerSubscription =
        managerBloc.stream.listen(mapRelationManagerStateToEvent);
  }

  static const String _errorRelationNotFound = 'Relation does not exist';

  final ID id;
  final GameCollectionRepository collectionRepository;
  final ItemRelationManagerBloc<T, ID, W> managerBloc;
  late StreamSubscription<ItemRelationManagerState> managerSubscription;

  Future<void> _checkConnection(Emitter<ItemRelationState> emit) async {
    await BlocUtils.checkConnection<ItemRelationState, ItemRelationNotLoaded>(
      collectionRepository.gameRepository,
      emit,
      (final String error) => ItemRelationNotLoaded(error),
    );
  }

  void _mapLoadToState(
    LoadItemRelation event,
    Emitter<ItemRelationState> emit,
  ) async {
    await _checkConnection(emit);

    emit(
      ItemRelationLoading(),
    );

    try {
      final List<W> items = await getRelationStream();
      emit(
        ItemRelationLoaded<W>(items),
      );
    } catch (e) {
      emit(
        ItemRelationNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateRelationToState(
    UpdateItemRelation<W> event,
    Emitter<ItemRelationState> emit,
  ) {
    emit(
      ItemRelationLoaded<W>(event.otherItems),
    );
  }

  void _mapUpdateItemToState(
    UpdateRelationItem<W> event,
    Emitter<ItemRelationState> emit,
  ) {
    if (state is ItemRelationLoaded<W>) {
      final List<W> items =
          List<W>.from((state as ItemRelationLoaded<W>).otherItems);

      final int listItemIndex =
          items.indexWhere((W item) => item.uniqueId == event.item.uniqueId);
      final W listItem = items.elementAt(listItemIndex);

      if (listItem != event.item) {
        items[listItemIndex] = event.item;

        emit(
          ItemRelationLoaded<W>(items),
        );
      }
    }
  }

  void mapRelationManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<W>) {
      _mapAddedToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<W>) {
      _mapDeletedToEvent(managerState);
    }
  }

  void _mapAddedToEvent(ItemRelationAdded<W> managerState) {
    if (state is ItemRelationLoaded<W>) {
      final List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = List<W>.from(items)
        ..add(managerState.otherItem);

      add(UpdateItemRelation<W>(updatedItems));
    }
  }

  void _mapDeletedToEvent(ItemRelationDeleted<W> managerState) {
    if (state is ItemRelationLoaded<W>) {
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
  @protected
  Future<List<W>> getRelationStream() {
    return Future<List<W>>.error(_errorRelationNotFound);
  }
}
