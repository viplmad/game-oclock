import 'package:game_oclock/models/models.dart'
    show
        FilterDTO,
        ListSearch,
        Login,
        OperatorType,
        SearchDTO,
        SearchValue,
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

Login mockLogin() {
  return const Login(
    host: 'http://localhost:8080',
    username: 'viplmad',
    password: '',
  );
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
