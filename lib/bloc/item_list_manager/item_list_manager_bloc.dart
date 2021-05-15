import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


abstract class ItemListManagerBloc<T extends CollectionItem> extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.iCollectionRepository,
  }) : super(Initialised());

  final ICollectionRepository iCollectionRepository;

  @override
  Stream<ItemListManagerState> mapEventToState(ItemListManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddItem<T>) {

      yield* _mapAddItemToState(event);

    } else if(event is DeleteItem<T>) {

      yield* _mapDeleteItemToState(event);

    }

    yield Initialised();

  }

  Stream<ItemListManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch (e) {

        yield ItemNotAdded(e.toString());

      }
    }

  }

  Stream<ItemListManagerState> _mapAddItemToState(AddItem<T> event) async* {

    try {

      final T? item = await createFuture(event);
      if(item != null) {
        yield ItemAdded<T>(item);
      } else {
        throw Exception();
      }

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  Stream<ItemListManagerState> _mapDeleteItemToState(DeleteItem<T> event) async* {

    try{

      await deleteFuture(event);
      yield ItemDeleted<T>(event.item);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Future<T?> createFuture(AddItem<T> event);
  Future<dynamic> deleteFuture(DeleteItem<T> event);
}