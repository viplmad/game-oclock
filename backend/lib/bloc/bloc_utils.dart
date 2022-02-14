import 'package:bloc/bloc.dart';

import 'package:backend/repository/repository.dart' show BaseRepository;

class BlocUtils {
  BlocUtils._();

  static const String _connectionLostMessage =
      'Connection lost. Trying to reconnect';

  // ignore: always_specify_types
  static Future<void> checkConnection<K extends Object, S extends K>(
    BaseRepository repository,
    Emitter<K> emit,
    S Function(String) notLoadedEvent,
  ) async {
    if (repository.isClosed()) {
      emit(
        notLoadedEvent(_connectionLostMessage),
      );

      try {
        repository.reconnect();
        await repository.open();
      } catch (e) {
        emit(
          notLoadedEvent(e.toString()),
        );
      }
    }
  }
}
