import 'dart:math';

import 'package:game_oclock/models/models.dart';

UserGame mockUserGame({final String? title}) {
  return UserGame(
    id: mockId(),
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
  return Tag(id: mockId(), name: name ?? 'name');
}

Location mockLocation({final String? name}) {
  return Location(id: mockId(), name: name ?? 'name');
}

LocationWithDate mockLocationWithDate({final String? name}) {
  return LocationWithDate(
    id: mockId(),
    name: name ?? 'name',
    date: DateTime.now(),
  );
}

Device mockDevice({final String? name}) {
  return Device(id: mockId(), name: name ?? 'name');
}

User mockUser() {
  return User(id: mockId(), username: 'username');
}

String mockId() => Random().nextInt(1000).toString();

Login mockLogin() {
  return const Login(
    host: 'http://localhost:8080',
    username: 'viplmad',
    password: '',
  );
}

SavedLoginResponse mockSavedLoginResponse() {
  return SavedLoginResponse(
    host: 'http://localhost:8080',
    username: 'viplmad2',
    tokenResponse: mockTokenResponse(),
  );
}

TokenResponse mockTokenResponse() {
  return TokenResponse(
    accessToken: 'eyj',
    expiresIn: 3600,
    refreshToken: 'MII',
    tokenType: 'bearer',
  );
}

PageResultDTO<T> mockPageResult<T>({
  required final SearchDTO search,
  required final String? quicksearch,
  required final T Function(int) builder,
}) {
  final page = search.page ?? 0;
  final size = search.size ?? 50;
  return PageResultDTO<T>(
    data: List.generate(size, (final index) {
      final finalIndex = (page * size) + index;
      return builder(finalIndex);
    }),
    page: page,
    size: size,
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
