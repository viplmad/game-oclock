import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show GameSession;

class GameSessionService {
  Future<GameSession> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockGameSession();
  }

  Future<void> create(final GameSession session) async {
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> update(final GameSession session) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
