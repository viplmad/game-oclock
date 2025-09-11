import 'package:http/http.dart';

import '../api_helper.dart';
import '../models/models.dart';
import 'base_api.dart';

class GamesApi extends BaseApi {
  GamesApi(super.apiClient);

  Future<Response> getGamesWithHttpInfo({String? search, int? size}) async {
    final fields = List.unmodifiable(<String>[
      'name',
      'cover.url',
      'first_release_date',
      'genres.name',
      'collections.name',
    ]);
    // ignore: prefer_const_declarations
    final path = r'/games';

    // ignore: prefer_final_locals
    Object? postBody =
        'search "$search";\n' +
        'fields ${fields.join(',')};\n' +
        'limit ${size ?? 10};';

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['text/plain'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<IGDBGame>> getGames({String? search, int? size}) async {
    final response = await getGamesWithHttpInfo(search: search, size: size);
    await checkResponse(response);
    return (await apiClient.deserializeAsync(
              await decodeBodyBytes(response),
              'List<IGDBGame>',
            )
            as List)
        .cast<IGDBGame>()
        .toList(growable: false);
  }
}
