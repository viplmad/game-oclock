import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show PageResultDTO, SearchDTO;

class GameLogService {
  Future<PageResultDTO<DateTime>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => DateTime.now().subtract(Duration(hours: index)),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }
}
