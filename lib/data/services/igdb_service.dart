import 'package:game_oclock/data/services/igdb/api/auth_api.dart';
import 'package:game_oclock/data/services/igdb/api/games_api.dart';
import 'package:game_oclock/data/services/igdb/api_client.dart';
import 'package:game_oclock/data/services/igdb/auth/api_key_auth.dart';
import 'package:game_oclock/data/services/igdb/auth/authentication.dart';
import 'package:game_oclock/data/services/igdb/auth/http_bearer_auth.dart';
import 'package:game_oclock/data/services/igdb/auth/multiple_auth.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame;

class IGDBService {
  IGDBService(final String clientId, final String clientSecret) {
    final authApi = AuthApi(ApiClient.auth());

    final httpBearerAuth = HttpBearerAuth();
    final apiClient = ApiClient(
      authentication: MultipleAuth(
        List.unmodifiable(<Authentication>[
          ApiKeyAuth('header', 'Client-ID')..apiKey = clientId,
          httpBearerAuth,
        ]),
        refresh: () => authApi
            .token('client_credentials', clientId, clientSecret)
            .then(
              (final token) => httpBearerAuth.accessToken = token.accessToken,
            ),
      ),
    );
    _api = GamesApi(apiClient);
  }

  late final GamesApi _api;

  Future<List<ExternalGame>> search(final String search) async {
    final data = await _api.getGames(search: search, size: 10);
    return data
        .map(
          (final game) => ExternalGame(
            externalSource: 'igdb',
            externalId: game.id.toString(),
            title: game.name,
            coverUrl: game.cover?.url,
            releaseDate: game.firstReleaseDate,
            genres: game.genres
                .map((final g) => g.name)
                .toList(growable: false),
            series: game.collections
                .map((final c) => c.name)
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }
}
