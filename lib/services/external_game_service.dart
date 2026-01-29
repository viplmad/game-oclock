import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show ExternalGame, PageResultDTO, SearchDTO;

class ExternalGameService {
  Future<PageResultDTO<ExternalGame>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockExternalGame(title: 'title ($quicksearch) $index'),
    );
  }
}
