import 'package:game_oclock/models/models.dart' show sourceIgdb;
import 'package:game_oclock_client/api.dart';

class ExternalGameService {
  final MediasApi _api;

  ExternalGameService(ApiClient apiClient) : _api = MediasApi(apiClient);

  Future<List<PotentialMediaDTO>> search(String quicksearch) async {
    return _api.searchExternalMedias(sourceIgdb, quicksearch);
  }
}
