import 'package:game_oclock/models/models.dart'
    show GameOClockException, errorCodeUnknown;
import 'package:game_oclock/services/services.dart' show ExternalGameService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class ExternalGameListBloc extends ListLoadBloc<PotentialMediaDTO> {
  ExternalGameListBloc({required this.service});

  final ExternalGameService service;

  @override
  Future<PageResultDTO<PotentialMediaDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    if (quicksearch == null) {
      throw GameOClockException(
        code: errorCodeUnknown,
        message: 'Quicksearch cannot be empty',
      );
    }

    final data = await service.search(quicksearch);
    return PageResultDTO(data: data, page: 0, size: 500);
  }

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
}
