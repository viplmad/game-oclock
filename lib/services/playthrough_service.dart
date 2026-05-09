import 'package:game_oclock/models/models.dart' show Playthrough;
import 'package:game_oclock_client/api.dart';

class PlaythroughService {
  Future<PageResultDTO<Playthrough>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> count(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<PageResultDTO<Playthrough>> searchForGame(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> countForGame(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<Playthrough> get(final String id) async {
    throw UnsupportedError('');
  }

  Future<String> create(final Playthrough playthrough) async {
    throw UnsupportedError('');
  }

  Future<void> update(final String id, final Playthrough playthrough) async {
    throw UnsupportedError('');
  }

  Future<void> delete(final String id) async {
    throw UnsupportedError('');
  }
}
