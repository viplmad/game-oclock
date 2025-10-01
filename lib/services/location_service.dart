import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show Location, PageResultDTO, SearchDTO;

class LocationService {
  Future<PageResultDTO<Location>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockLocation(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<void> create(final Location location) async {
    await Future.delayed(const Duration(seconds: 5));
  }
}
