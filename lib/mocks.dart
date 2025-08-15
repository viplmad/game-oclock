import 'package:game_oclock/models/models.dart'
    show
        FilterDTO,
        GameAvailable,
        ListSearch,
        Login,
        OperatorType,
        PageResultDTO,
        SearchDTO,
        SearchValue,
        Tag,
        UserGame;

UserGame mockUserGame({final String? title}) {
  return UserGame(
    id: 'lkdasmdlknuhiuahfksdjfha',
    externalId: 'steam',
    title: title ?? 'title',
    edition: '',
    releaseDate: DateTime.now(),
    genres: [],
    series: [],
    coverUrl:
        'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/224760/header.jpg',
    status: 'Played',
    rating: 9,
    notes: 'cosas',
  );
}

Tag mockTag({final String? name}) {
  return Tag(id: '12839127u3', name: name ?? 'name');
}

GameAvailable mockGameAvailable({final String? name}) {
  return GameAvailable(
    id: 'askdnaskldas',
    name: name ?? 'name',
    date: DateTime.now(),
  );
}

Login mockLogin() {
  return const Login(
    host: 'http://localhost:8080',
    username: 'viplmad',
    password: '',
  );
}

PageResultDTO<T> mockPageResult<T>({
  required final ListSearch search,
  required final String? quicksearch,
  required final T Function(int) builder,
}) {
  final page = search.search.page ?? 0;
  final size = search.search.size ?? 50;
  return PageResultDTO<T>(
    data: List.generate(size, (final index) {
      final finalIndex = (page * size) + index;
      return builder(finalIndex);
    }),
    page: page,
    size: size,
  );
}

List<T> mergePageData<T>({
  required final ListSearch search,
  required final PageResultDTO<T> page,
  required final List<T>? lastData,
}) {
  List<T> finalData;
  if ((search.search.page ?? 0) == 0) {
    finalData = page.data;
  } else {
    finalData = List.of(
      lastData == null ? page.data : [...lastData, ...page.data],
      growable: false,
    );
  }
  return finalData;
}

ListSearch mockSearch({final String? name, final int filters = 0}) {
  return ListSearch(
    name: name ?? 'search',
    search: SearchDTO(
      filter: List.generate(
        filters,
        (final index) => mockFilterDTO(field: 'field$index'),
      ),
    ),
  );
}

FilterDTO mockFilterDTO({final String? field}) {
  return FilterDTO(
    field: field ?? 'field',
    operator_: OperatorType.eq,
    value: SearchValue(value: 'value'),
  );
}
