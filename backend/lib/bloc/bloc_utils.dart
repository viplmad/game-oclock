import 'package:bloc/bloc.dart';

import 'package:backend/repository/repository.dart' show ItemRepository;


class BlocUtils {
  BlocUtils._();

  static const String _connectionLostMessage = 'Connection lost. Trying to reconnect';

  // ignore: always_specify_types
  static Future<void> checkConnection<K extends Object, S extends K>(ItemRepository itemRepository, Emitter<K> emit, S Function(String) notLoadedEvent) async {

    if(itemRepository.isClosed()) {
      emit(
        notLoadedEvent(_connectionLostMessage),
      );

      try {

        itemRepository.reconnect();
        await itemRepository.open();

      } catch (e) {

        emit(
          notLoadedEvent(e.toString()),
        );

      }
    }

  }
}