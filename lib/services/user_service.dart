import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, User;

class UserService {
  Future<PageResultDTO<User>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => mockUser(),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<void> create(final User user) async {
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<User> getCurrent() async {
    return mockUser();
  }
}
