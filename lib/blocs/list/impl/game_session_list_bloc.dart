import 'package:game_oclock/services/services.dart'
    show GameService, SessionService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class GameSessionListBloc extends ListLoadBloc<SessionDTO> {
  GameSessionListBloc({required this.service, required this.gameId});

  final SessionService service;
  final String gameId;

  @override
  Future<PageResultDTO<SessionDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(gameId, search, quicksearch);

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
  /*service.countForGame(
        gameId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );*/
}

class SessionWithMediaListBloc extends ListLoadBloc<MediaSessionDTO> {
  SessionWithMediaListBloc({required this.service, required this.gameService})
    : mediaCache = <String, MediaDTO>{};

  final SessionService service;
  final GameService gameService;
  final Map<String, MediaDTO> mediaCache;

  @override
  Future<PageResultDTO<MediaSessionDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final sessions = await service.search(search, quicksearch);
    await fetchMedias(sessions);
    return PageResultDTOMediaSessionDTO(
      page: sessions.page,
      size: sessions.size,
      data: sessions.data
          .map(
            (final s) =>
                MediaSessionDTO(media: mediaCache[s.mediaId]!, session: s),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
  /*service.count(AggregateSearch(filter: search.filter), quicksearch);*/

  Future<void> fetchMedias(final PageResultDTO<SessionDTO> sessions) async {
    final mediaIds = sessions.data
        .map((final el) => el.mediaId)
        .where((final id) => !mediaCache.containsKey(id))
        .toSet()
        .toList(growable: false);
    if (mediaIds.isEmpty) {
      return;
    }
    final medias = await gameService.search(
      ListSearchDTO(
        filter: List.unmodifiable(<FilterDTO>[
          FilterDTO(
            field: 'id',
            operator_: OperatorType.in_,
            value: SearchValue(values: mediaIds),
            chainOperator: ChainOperatorType.and,
          ),
        ]),
        size: 5,
      ),
      null,
    );
    medias.data.forEach((final m) {
      mediaCache[m.media.id] = m;
    });
  }
}
