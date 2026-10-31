import 'package:game_oclock/models/models.dart'
    show NewPlaythrough, Playthrough;
import 'package:game_oclock_client/api.dart';

class PlaythroughService {
  Future<PageResultDTO<Playthrough>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> count(ListSearchDTO search, String? quicksearch) async {
    throw UnsupportedError('');
  }

  Future<PageResultDTO<Playthrough>> searchForGame(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> countForGame(ListSearchDTO search, String? quicksearch) async {
    throw UnsupportedError('');
  }

  Future<Playthrough> get(String id) async {
    throw UnsupportedError('');
  }

  Future<String> create(NewPlaythrough playthrough) async {
    throw UnsupportedError('');
  }

  Future<void> update(String id, NewPlaythrough playthrough) async {
    throw UnsupportedError('');
  }

  Future<void> delete(String id) async {
    throw UnsupportedError('');
  }
}
