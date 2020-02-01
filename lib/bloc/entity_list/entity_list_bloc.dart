import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/entity.dart';

import 'entity_list.dart';

abstract class EntityListBloc extends Bloc<EntityListEvent, EntityListState> {

  final ICollectionRepository collectionRepository;
  StreamSubscription _collectionSubscription;

  EntityListBloc({@required this.collectionRepository});

  @override
  EntityListState get initialState => EntityListLoading();

  @override
  Stream<EntityListState> mapEventToState(EntityListEvent event) async* {

    if(event is LoadEntityList) {

      yield* _mapLoadToState();

    } else if(event is AddEntity) {

      yield* _mapAddToState(event);

    } else if(event is DeleteEntity) {

      yield* _mapDeleteToState(event);

    } else if(event is UpdateEntityList) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<EntityListState> _mapLoadToState() async* {

    yield EntityListLoading();

    try {

      _collectionSubscription?.cancel();
      _collectionSubscription = getReadStream().listen( (List<Entity> entities) {
        add(UpdateEntityList(entities));
      });

    } catch (e) {

      yield EntityListNotLoaded(e.toString());

    }

  }

  Stream<EntityListState> _mapAddToState(AddEntity event) async* {

    try {

      if(state is EntityListLoaded) {
        await getCreateStream(event.entity);
        final List<Entity> updatedEntities = List.from((state as EntityListLoaded)
            .entities)..add(event.entity);

        yield EntityListLoaded(
          updatedEntities,
        );
      }

    } catch (e) {

      yield EntityListNotLoaded(e.toString());

    }

  }

  Stream<EntityListState> _mapDeleteToState(DeleteEntity event) async* {

    try {

      if(state is EntityListLoaded) {
        await getDeleteStream(event.entity);
        final List<Entity> updatedEntities = (state as EntityListLoaded)
            .entities
            .where((Entity entity) => entity.ID != event.entity.ID)
            .toList();
        
        yield EntityListLoaded(
          updatedEntities,
        );
      }

    } catch (e) {

      yield EntityListNotLoaded(e.toString());

    }

  }

  Stream<EntityListState> _mapUpdateToState(UpdateEntityList event) async* {

    yield EntityListLoaded(event.entities);

  }

  @override
  Future<void> close() {

    _collectionSubscription?.cancel();
    return super.close();

  }

  external Stream<List<Entity>> getReadStream();
  external Stream<dynamic> getCreateStream(Entity entity);
  external Stream<dynamic> getDeleteStream(Entity entity);

}