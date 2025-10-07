import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show GamePlaythrough;

class GamePlaythroughService {
  Future<GamePlaythrough> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockGamePlaythrough();
  }

  Future<void> create(final GamePlaythrough playthrough) async {
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> update(final GamePlaythrough playthrough) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
