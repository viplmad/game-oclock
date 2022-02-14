import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../bloc_utils.dart';
import 'item_search.dart';

abstract class ItemRemoteSearchBloc<
    T extends Item,
    E extends ItemEntity,
    ID extends Object,
    R extends ItemRepository<E, ID>> extends ItemSearchBloc<T> {
  ItemRemoteSearchBloc({
    required this.repository,
    required this.viewIndex,
  }) : super();

  final R repository;
  final int? viewIndex;

  Future<void> _checkConnection(Emitter<ItemSearchState> emit) async {
    await BlocUtils.checkConnection<ItemSearchState, ItemSearchError>(
      repository,
      emit,
      (final String error) => ItemSearchError(error),
    );
  }

  @override
  Future<void> mapTextChangedToState(
    SearchTextChanged event,
    Emitter<ItemSearchState> emit,
  ) async {
    await _checkConnection(emit);

    await super.mapTextChangedToState(event, emit);
  }
}
